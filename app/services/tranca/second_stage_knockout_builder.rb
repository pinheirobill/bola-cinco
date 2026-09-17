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

    private

    def second_stage_complete?
      matches = @championship.tranca_partidas.for_stage(2).where(phase: "classificatoria")
      matches.count == 24 && matches.all?(&:finished?)
    end

    def existing_quarterfinals?
      @championship.tranca_partidas.for_stage(2).where(phase: "mata_mata").where("source_id LIKE ?", "tranca-stage-2-qf-%").exists?
    end
  end
end
