module Tranca
  class SecondStageKnockoutBuilder
    class InvalidStateError < StandardError; end
    PAIRINGS = { "QF1" => [%w[A 1], %w[B 2]], "QF2" => [%w[B 1], %w[A 2]], "QF3" => [%w[C 1], %w[D 2]], "QF4" => [%w[D 1], %w[C 2]] }.freeze

    def initialize(championship)
      @championship = championship
    end

    def create!
      @championship.with_lock do
        raise InvalidStateError, "As 24 partidas da 2ª etapa precisam estar finalizadas." unless second_stage_complete?
        raise InvalidStateError, "As quartas de final já foram criadas." if existing_quarterfinals?
        rows = @championship.tranca_classificacao_rows.for_stage(2).includes(:tranca_dupla).index_by { |row| [row.group_key.to_s, row.position.to_i] }
        raise InvalidStateError, "A classificação da 2ª etapa está incompleta." unless PAIRINGS.values.flatten.all? { |key| rows.key?(key) }
        rodada = @championship.tranca_rodadas.create!(stage_number: 2, phase: "mata_mata", round_number: 1, source_id: "tranca-stage-2-quarterfinals-#{@championship.id}", label: "2ª etapa · Quartas de final", status: "programada")
        PAIRINGS.each_with_index do |(code, sides), index|
          mesa = @championship.tranca_mesas.create!(tranca_rodada: rodada, source_id: "tranca-stage-2-qf-table-#{@championship.id}-#{index + 1}", code: "E2-QF-M#{index + 1}", name: "Mesa #{index + 1}", status: "disponivel")
          @championship.tranca_partidas.create!(category: rows.fetch(sides.first).category, tranca_rodada: rodada, tranca_mesa: mesa, dupla_a: rows.fetch(sides.first).tranca_dupla, dupla_b: rows.fetch(sides.last).tranca_dupla, stage_number: 2, source_id: "tranca-stage-2-qf-#{@championship.id}-#{code}", code: "E2-#{code}", phase: "mata_mata", round_number: 1, status: :agendado, source_data: { "generated_by" => self.class.name, "bracket_code" => code, "winner_target" => code.in?(%w[QF1 QF2]) ? "SF1" : "SF2" })
        end
        rodada
      end
    end

    def advance!(partida)
      @championship.with_lock do
        code = partida.source_data["bracket_code"]
        case code
        when "QF1", "QF2", "QF3", "QF4"
          create_semifinals! if round_finished?("QF1", "QF2", "QF3", "QF4")
        when "SF1", "SF2"
          create_final_and_third_place! if round_finished?("SF1", "SF2")
        end
      end
    end

    private

    def second_stage_complete?
      matches = @championship.tranca_partidas.for_stage(2).where(phase: "classificatoria")
      matches.count == 24 && matches.all?(&:finished?)
    end

    def existing_quarterfinals?
      @championship.tranca_partidas.for_stage(2).where(phase: "mata_mata").where("source_id LIKE ?", "tranca-stage-2-qf-%").exists?
    end

    def matches_for(*codes)
      @championship.tranca_partidas.for_stage(2).where(phase: "mata_mata").select { |match| codes.include?(match.source_data["bracket_code"]) }
    end

    def round_finished?(*codes)
      matches = matches_for(*codes)
      matches.size == codes.size && matches.all? { |match| match.finished? && match.winner.present? }
    end

    def create_semifinals!
      return if matches_for("SF1", "SF2").any?
      qf = matches_for("QF1", "QF2", "QF3", "QF4").index_by { |match| match.source_data["bracket_code"] }
      rodada = @championship.tranca_rodadas.create!(stage_number: 2, phase: "mata_mata", round_number: 2, source_id: "tranca-stage-2-semifinals-#{@championship.id}", label: "2ª etapa · Semifinais", status: "programada")
      create_elimination_match!(rodada, "SF1", qf.fetch("QF1").winner, qf.fetch("QF2").winner, 1, "FINAL", "THIRD_PLACE")
      create_elimination_match!(rodada, "SF2", qf.fetch("QF3").winner, qf.fetch("QF4").winner, 2, "FINAL", "THIRD_PLACE")
    end

    def create_final_and_third_place!
      return if matches_for("FINAL", "THIRD_PLACE").any?
      semifinals = matches_for("SF1", "SF2").index_by { |match| match.source_data["bracket_code"] }
      rodada = @championship.tranca_rodadas.create!(stage_number: 2, phase: "mata_mata", round_number: 3, source_id: "tranca-stage-2-final-#{@championship.id}", label: "2ª etapa · Final e 3º lugar", status: "programada")
      create_elimination_match!(rodada, "FINAL", semifinals.fetch("SF1").winner, semifinals.fetch("SF2").winner, 1)
      create_elimination_match!(rodada, "THIRD_PLACE", loser_of(semifinals.fetch("SF1")), loser_of(semifinals.fetch("SF2")), 2)
    end

    def loser_of(match)
      match.dupla_a_id == match.winner_id ? match.association(:dupla_b).reader : match.association(:dupla_a).reader
    end

    def create_elimination_match!(rodada, code, dupla_a, dupla_b, table_number, *targets)
      mesa = @championship.tranca_mesas.create!(tranca_rodada: rodada, source_id: "tranca-stage-2-#{code.downcase}-table-#{@championship.id}", code: "E2-#{code}-M#{table_number}", name: "Mesa #{table_number}", status: "disponivel")
      @championship.tranca_partidas.create!(category: dupla_a.category, tranca_rodada: rodada, tranca_mesa: mesa, dupla_a: dupla_a, dupla_b: dupla_b, stage_number: 2, source_id: "tranca-stage-2-#{code.downcase}-#{@championship.id}", code: "E2-#{code}", phase: "mata_mata", round_number: rodada.round_number, status: :agendado, source_data: { "generated_by" => self.class.name, "bracket_code" => code, "next_targets" => targets })
    end
  end
end
