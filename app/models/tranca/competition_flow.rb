module Tranca
  class CompetitionFlow
    class NoAvailableMatchupsError < StandardError; end

    attr_reader :championship

    def initialize(championship)
      @championship = championship
    end

    def classificatoria_pairings_available?(round_number:)
      championship.categories.includes(:teams).any? do |category|
        dupla_ids = championship.tranca_duplas.where(category_id: category.id).pluck(:id)
        used_matchups = championship.tranca_partidas
          .where(category_id: category.id, phase: "classificatoria")
          .where("round_number < ?", round_number.to_i)
          .pluck(:dupla_a_id, :dupla_b_id)
          .each_with_object({}) do |(first_id, second_id), matchups|
            next if first_id.blank? || second_id.blank?

            matchups[matchup_key(first_id, second_id)] = true
          end

        # Page rendering only needs to know whether one unused matchup exists.
        # Do not generate all possible rounds just to enable the button.
        dupla_ids.combination(2).any? { |first_id, second_id| !used_matchups[matchup_key(first_id, second_id)] }
      end
    end

    def knockout_finished?
      categories_with_knockout_matches = championship.categories.select do |category|
        championship.tranca_partidas.where(category_id: category.id, phase: "mata_mata").exists?
      end
      return false if categories_with_knockout_matches.empty?

      categories_with_knockout_matches.all? do |category|
        final_round = championship.tranca_rodadas
          .joins(:partidas)
          .where(phase: "mata_mata", tranca_partidas: { category_id: category.id })
          .order(round_number: :desc)
          .first

        final_round.present? && final_round.partidas.one? && final_round.partidas.all? { |partida| partida.finished? && partida.winner.present? }
      end
    end

    def generate_round!(phase:, round_number:)
      return generate_knockout_round!(round_number: round_number) if phase.to_s == "mata_mata"

      pairings_by_category = championship.categories.includes(:teams).order(:name).to_h do |category|
        [ category, pairings_for(category, phase: phase, round_number: round_number) ]
      end
      raise NoAvailableMatchupsError if pairings_by_category.values.none?(&:any?)

      rodada = championship.tranca_rodadas.find_or_initialize_by(
        phase: phase.to_s,
        round_number: round_number.to_i
      )
      rodada.assign_attributes(
        championship: championship,
        source_id: round_source_id(phase, round_number),
        label: round_label(phase, round_number),
        status: "programada"
      )
      rodada.save!

      pairings_by_category.each do |category, pairings|
        pairings.each_with_index do |(dupla_a, dupla_b), index|
          next if dupla_a.blank? || dupla_b.blank?

          partida = championship.tranca_partidas.find_or_initialize_by(
            source_id: partita_source_id(category, phase, round_number, index + 1)
          )
          partida.assign_attributes(
            championship: championship,
            category: category,
            tranca_rodada: rodada,
            code: partida_code(category, phase, round_number, index + 1),
            phase: phase.to_s,
            round_number: round_number.to_i,
            status: :agendado,
            dupla_a: dupla_a,
            dupla_b: dupla_b,
            source_data: {
              "generated_by" => "tranca_competition_flow"
            }
          )
          partida.save!
        end
      end

      rodada
    end

    def generate_knockout_round!(round_number:)
      rodada = championship.tranca_rodadas.find_or_initialize_by(
        phase: "mata_mata",
        round_number: round_number.to_i
      )
      rodada.assign_attributes(
        championship: championship,
        source_id: round_source_id("mata_mata", round_number),
        label: round_label("mata_mata", round_number),
        status: "programada"
      )
      rodada.save!

      championship.categories.includes(:teams).order(:name).each do |category|
        pairings_for_knockout(category, round_number).each_with_index do |(dupla_a, dupla_b), index|
          next if dupla_a.blank? || dupla_b.blank?

          partida = championship.tranca_partidas.find_or_initialize_by(
            source_id: knockout_partida_source_id(category, round_number, index + 1)
          )
          partida.assign_attributes(
            championship: championship,
            category: category,
            tranca_rodada: rodada,
            code: knockout_partida_code(category, round_number, index + 1),
            phase: "mata_mata",
            round_number: round_number.to_i,
            status: :agendado,
            dupla_a: dupla_a,
            dupla_b: dupla_b,
            source_data: {
              "generated_by" => "tranca_competition_flow",
              "kind" => "knockout"
            }
          )
          partida.save!
        end
      end

      rodada
    end

    def assign_mesas!(rodada)
      rodada.partidas.includes(:tranca_mesa).order(:id).each_with_index do |partida, index|
        mesa = championship.tranca_mesas.find_or_initialize_by(source_id: mesa_source_id(partida))
        mesa.assign_attributes(
          championship: championship,
          tranca_rodada: rodada,
          code: mesa_code(rodada, index + 1),
          name: "Mesa #{index + 1}",
          location: nil,
          status: mesa_status_for(partida.status)
        )
        mesa.save!

        partida.update!(tranca_mesa: mesa)
      end
    end

    def record_result!(partida:, score_a:, score_b:, status: :finalizado, winner_id: nil, decision: nil, wo: nil, maos_attributes: nil)
      sync_maos!(partida, maos_attributes) if maos_attributes.present?

      score_a, score_b = scores_for_partida(partida) if maos_attributes.present?

      attrs = {
        score_a: score_a,
        score_b: score_b,
        status: status.to_s,
        decision: decision,
        wo: wo
      }

      attrs[:winner] = winner_for(partida, score_a, score_b, winner_id, status, wo)
      partida.update!(attrs)
      rebuild_classificacao!
      advance_knockout_from!(partida) if partida.knockout_phase?
      championship.update!(status: :finalizado) if knockout_finished?
      partida
    end

    def sync_maos!(partida, maos_attributes)
      return if maos_attributes.blank?

      normalized_maos = normalize_maos_attributes(maos_attributes)
      existing_maos = partida.maos.index_by(&:source_id)
      keep_source_ids = []
      return if normalized_maos.all? { |attributes| hand_blank?(attributes) } && existing_maos.blank?

      Tranca::Partida.transaction do
        normalized_maos.each_with_index do |attributes, index|
          next if hand_blank?(attributes)

          source_id = attributes[:source_id].presence || hand_source_id(partida, index + 1)
          mao = existing_maos[source_id] || partida.maos.find_or_initialize_by(source_id: source_id)
          mao.assign_attributes(
            championship: championship,
            numero: attributes[:numero].presence || index + 1,
            pontos_a: attributes[:pontos_a].presence || 0,
            pontos_b: attributes[:pontos_b].presence || 0,
            canastra_limpa_a: boolean_from(attributes[:canastra_limpa_a]),
            canastra_limpa_b: boolean_from(attributes[:canastra_limpa_b]),
            canastra_suja_a: boolean_from(attributes[:canastra_suja_a]),
            canastra_suja_b: boolean_from(attributes[:canastra_suja_b]),
            batida_a: boolean_from(attributes[:batida_a]),
            batida_b: boolean_from(attributes[:batida_b]),
            tres_vermelho_a: boolean_from(attributes[:tres_vermelho_a]),
            tres_vermelho_b: boolean_from(attributes[:tres_vermelho_b]),
            desconto_a: attributes[:desconto_a].presence || 0,
            desconto_b: attributes[:desconto_b].presence || 0,
            observacoes: attributes[:observacoes].presence,
            source_data: {
              "generated_by" => "tranca_competition_flow"
            }
          )
          mao.save!
          keep_source_ids << mao.source_id
        end

        partida.maos.where.not(source_id: keep_source_ids).destroy_all
        if keep_source_ids.any? || existing_maos.any?
          partida.clear_hand_scores!
        end
      end
    end

    def rebuild_classificacao!
      championship.tranca_classificacao_rows.delete_all

      championship.tranca_duplas.includes(:category).group_by(&:category).each do |category, duplas|
        rebuild_category_classificacao!(category, duplas)
      end
    end

    private

    def rebuild_category_classificacao!(category, duplas)
      groups = championship.tranca_partidas.where(category_id: category.id).group_by { |partida| partida.group_key.to_s }
      groups = { "" => [] } if groups.empty?

      groups.each do |group_key, partidas|
        stats_by_dupla = duplas.index_by(&:id).transform_values { |dupla| standing_stats_for(dupla, group_key) }

        partidas.select(&:finished?).each do |partida|
          apply_partida_to_stats!(stats_by_dupla, partida)
        end

        sorted_stats = stats_by_dupla.values.sort_by do |stats|
          [
            -stats[:points],
            -stats[:goal_diff],
            -stats[:goals_for],
            -stats[:wins],
            stats[:dupla].name.to_s.downcase
          ]
        end

        sorted_stats.each_with_index do |stats, index|
          championship.tranca_classificacao_rows.create!(
            category: category,
            tranca_dupla: stats[:dupla],
            source_id: classification_source_id(category, group_key, stats[:dupla]),
            group_key: group_key,
            position: index + 1,
            played: stats[:played],
            wins: stats[:wins],
            draws: stats[:draws],
            losses: stats[:losses],
            goals_for: stats[:goals_for],
            goals_against: stats[:goals_against],
            goal_diff: stats[:goal_diff],
            points: stats[:points],
            qualified: qualified_for_group?(index)
          )
        end
      end
    end

    def apply_partida_to_stats!(stats_by_dupla, partida)
      team_a = partida.association(:dupla_a).reader
      team_b = partida.association(:dupla_b).reader
      return if team_a.blank? || team_b.blank?

      team_a_stats = stats_by_dupla[team_a.id]
      team_b_stats = stats_by_dupla[team_b.id]
      return if team_a_stats.blank? || team_b_stats.blank?

      if partida.status_wo? && partida.winner.present?
        apply_wo_to_stats!(team_a_stats, team_b_stats, partida)
        return
      end

      score_a, score_b = scores_for_partida(partida)
      return if score_a.blank? || score_b.blank?

      team_a_goals = score_a.to_i
      team_b_goals = score_b.to_i

      team_a_stats[:played] += 1
      team_b_stats[:played] += 1
      team_a_stats[:goals_for] += team_a_goals
      team_a_stats[:goals_against] += team_b_goals
      team_b_stats[:goals_for] += team_b_goals
      team_b_stats[:goals_against] += team_a_goals

      if team_a_goals > team_b_goals
        apply_match_points!(team_a_stats, team_b_stats)
      elsif team_b_goals > team_a_goals
        apply_match_points!(team_b_stats, team_a_stats)
      else
        team_a_stats[:draws] += 1
        team_b_stats[:draws] += 1
        team_a_stats[:points] += championship.scoring_data.fetch("draw", 1).to_i
        team_b_stats[:points] += championship.scoring_data.fetch("draw", 1).to_i
      end

      finalize_stats!(team_a_stats)
      finalize_stats!(team_b_stats)
    end

    def apply_match_points!(winner_stats, loser_stats)
      winner_stats[:wins] += 1
      loser_stats[:losses] += 1
      winner_stats[:points] += championship.scoring_data.fetch("win", 3).to_i
      loser_stats[:points] += championship.scoring_data.fetch("loss", 0).to_i
    end

    def apply_wo_to_stats!(winner_stats, loser_stats, partida)
      winner_stats[:played] += 1
      loser_stats[:played] += 1
      winner_stats[:wins] += 1
      loser_stats[:losses] += 1
      winner_stats[:goals_for] += championship.scoring_data.fetch("woScore", 1).to_i
      loser_stats[:goals_against] += championship.scoring_data.fetch("woScore", 1).to_i
      winner_stats[:points] += championship.scoring_data.fetch("win", 3).to_i
      loser_stats[:points] += championship.scoring_data.fetch("wo", 0).to_i

      finalize_stats!(winner_stats)
      finalize_stats!(loser_stats)
    end

    def finalize_stats!(stats)
      stats[:goal_diff] = stats[:goals_for] - stats[:goals_against]
    end

    def standing_stats_for(dupla, group_key)
      {
        dupla: dupla,
        group_key: group_key.to_s,
        played: 0,
        wins: 0,
        draws: 0,
        losses: 0,
        goals_for: 0,
        goals_against: 0,
        goal_diff: 0,
        points: 0
      }
    end

    def qualified_for_group?(index)
      championship.group_stage_and_knockout_mode? ? index < championship.qualified_per_group : nil
    end

    def pairings_for(category, phase:, round_number:)
      duplas = championship.tranca_duplas.where(category_id: category.id).order(:name).to_a
      used_matchups = championship.tranca_partidas
        .where(category_id: category.id, phase: phase.to_s)
        .where("round_number < ?", round_number.to_i)
        .pluck(:dupla_a_id, :dupla_b_id)
        .each_with_object({}) do |(dupla_a_id, dupla_b_id), matchups|
          next if dupla_a_id.blank? || dupla_b_id.blank?

          matchups[matchup_key(dupla_a_id, dupla_b_id)] = true
        end

      pairings = best_pairings(duplas, used_matchups)
      pairings unless repeated_matchups(pairings, used_matchups).positive?
    end

    def best_pairings(duplas, used_matchups)
      return [] if duplas.empty?

      first_dupla = duplas.first
      opponents = duplas.drop(1)
      best = best_pairings(opponents, used_matchups)

      opponents.each_with_index do |opponent, index|
        remaining = opponents[0...index] + opponents[(index + 1)..]
        candidate = [ [ first_dupla, opponent ] ] + best_pairings(remaining, used_matchups)
        best = preferred_pairings(candidate, best, used_matchups)
      end

      best
    end

    def preferred_pairings(candidate, current, used_matchups)
      candidate_score = [ repeated_matchups(candidate, used_matchups), -candidate.size ]
      current_score = [ repeated_matchups(current, used_matchups), -current.size ]
      (candidate_score <=> current_score) == -1 ? candidate : current
    end

    def repeated_matchups(pairings, used_matchups)
      pairings.count { |dupla_a, dupla_b| used_matchups[matchup_key(dupla_a.id, dupla_b.id)] }
    end

    def matchup_key(dupla_a_id, dupla_b_id)
      [ dupla_a_id, dupla_b_id ].sort
    end

    def round_source_id(phase, round_number)
      "tranca-round-#{championship.id}-#{phase}-#{round_number}"
    end

    def round_label(phase, round_number)
      phase_label = case phase.to_s
      when "classificatoria" then "Classificatória"
      when "mata_mata" then "Mata-mata"
      else phase.to_s.tr("_", " ").humanize
      end

      "Rodada #{round_number} · #{phase_label}"
    end

    def partita_source_id(category, phase, round_number, index)
      "tranca-partida-#{championship.id}-#{category.id}-#{phase}-#{round_number}-#{index}"
    end

    def partida_code(category, phase, round_number, index)
      [
        category.name.parameterize.presence || "CAT",
        phase.to_s.parameterize.presence || "phase",
        round_number,
        index
      ].join("-").upcase
    end

    def mesa_source_id(partida)
      "tranca-mesa-#{partida.source_id}"
    end

    def mesa_code(rodada, index)
      "#{rodada.round_number}-#{index}"
    end

    def mesa_status_for(status)
      case status.to_s
      when "finalizado", "wo" then "ocupada"
      when "em_andamento" then "em_uso"
      else "disponivel"
      end
    end

    def winner_for(partida, score_a, score_b, winner_id, status, wo)
      return partida.winner if status.to_s != "wo" && score_a.to_i == score_b.to_i

      if winner_id.present?
        championship.tranca_duplas.find_by(id: winner_id)
      elsif score_a.to_i > score_b.to_i
        partida.association(:dupla_a).reader
      elsif score_b.to_i > score_a.to_i
        partida.association(:dupla_b).reader
      else
        partida.winner
      end
    end

    def classification_source_id(category, group_key, dupla)
      "tranca-classification-#{championship.id}-#{category.id}-#{group_key.presence || 'general'}-#{dupla.id}"
    end

    def advance_knockout_from!(partida)
      return unless partida.finished?

      current_round = partida.round_number.to_i
      return if current_round <= 0
      return unless knockout_round_complete?(partida.category, current_round)

      next_round_participants = knockout_winners_for(partida.category, current_round)
      return if next_round_participants.size < 2

      generate_knockout_round!(round_number: current_round + 1)
    end

    def pairings_for_knockout(category, round_number)
      participants = knockout_participants_for(category, round_number)
      half = participants.size / 2
      left_side = participants.first(half)
      right_side = participants.last(half).reverse

      left_side.zip(right_side)
    end

    def knockout_participants_for(category, round_number)
      round_number = round_number.to_i
      return qualified_knockout_participants_for(category) if round_number <= 1

      return [] unless knockout_round_complete?(category, round_number - 1)

      knockout_winners_for(category, round_number - 1)
    end

    def qualified_knockout_participants_for(category)
      rows = championship.tranca_classificacao_rows.where(category_id: category.id)
      rows = rows.where(qualified: true) if rows.where(qualified: true).exists?
      rows = rows.order(position: :asc, points: :desc, goal_diff: :desc, goals_for: :desc)

      duplas = rows.map(&:tranca_dupla).compact
      duplas = championship.tranca_duplas.where(category_id: category.id).order(:name).to_a if duplas.blank?
      duplas
    end

    def knockout_round_complete?(category, round_number)
      matches = championship.tranca_partidas.where(category_id: category.id, phase: "mata_mata", round_number: round_number)
      matches.exists? && matches.all?(&:finished?)
    end

    def knockout_winners_for(category, round_number)
      championship.tranca_partidas
        .includes(:winner)
        .where(category_id: category.id, phase: "mata_mata", round_number: round_number)
        .order(:id)
        .map(&:winner)
        .compact
    end

    def knockout_partida_source_id(category, round_number, index)
      "tranca-knockout-#{championship.id}-#{category.id}-#{round_number}-#{index}"
    end

    def knockout_partida_code(category, round_number, index)
      [
        category.name.parameterize.presence || "CAT",
        "K",
        round_number,
        index
      ].join("-").upcase
    end

    def scores_for_partida(partida)
      return [ partida.score_a, partida.score_b ] if partida.maos.blank?

      [ partida.maos.sum(:pontos_a).to_i, partida.maos.sum(:pontos_b).to_i ]
    end

    def normalize_maos_attributes(maos_attributes)
      Array(maos_attributes).flat_map do |item|
        case item
        when ActionController::Parameters
          item.to_unsafe_h
        when Hash
          item
        else
          {}
        end
      end.map { |attributes| attributes.to_h.symbolize_keys }
    end

    def hand_blank?(attributes)
      attributes.values_at(:numero, :pontos_a, :pontos_b, :observacoes).all? { |value| value.blank? } &&
        attributes.values_at(:canastra_limpa_a, :canastra_limpa_b, :canastra_suja_a, :canastra_suja_b, :batida_a, :batida_b, :tres_vermelho_a, :tres_vermelho_b).none? { |value| value.present? }
    end

    def boolean_from(value)
      !!ActiveModel::Type::Boolean.new.cast(value)
    end

    def hand_source_id(partida, index)
      "#{partida.source_id}-mao-#{index}"
    end
  end
end
