module Tranca
  class Dashboard
    attr_reader :championship

    def initialize(championship)
      @championship = championship
    end

    def categories
      championship.categories.includes(:championships).order(:name)
    end

    def entities
      Entity.order(:name)
    end

    def duplas
      @duplas ||= championship.tranca_duplas.includes(:entity, :category, memberships: :athlete).order(:name)
    end

    def duplas_by_category
      duplas.group_by(&:category_id).transform_values { |duplas_for_category| duplas_for_category.sort_by(&:name) }
    end

    def partidas
      @partidas ||= championship.tranca_partidas.includes(:category, :dupla_a, :dupla_b, :winner, :tranca_mesa, :tranca_rodada, :maos).order(
        scheduled_on: :asc,
        scheduled_time: :asc,
        id: :asc
      )
    end

    def knockout_partidas
      @knockout_partidas ||= partidas.select(&:knockout_phase?)
    end

    def rodadas
      @rodadas ||= championship.tranca_rodadas.includes(:partidas).order(
        phase: :asc,
        round_number: :asc,
        id: :asc
      )
    end

    def knockout_rounds
      rodadas.select(&:mata_mata?)
    end

    def championship_winners
      return [] unless knockout_rounds.any?

      knockout_rounds
        .group_by { |round| round.partidas.first&.category_id }
        .values
        .filter_map do |rounds|
          final = rounds.max_by(&:round_number)
          final.partidas.one? && final.partidas.first.finished? ? final.partidas.first.winner : nil
        end
        .compact
        .uniq
    end

    def classificacao_rows
      @classificacao_rows ||= championship.tranca_classificacao_rows.includes(:tranca_dupla, :category).order(
        position: :asc,
        points: :desc,
        goal_diff: :desc
      )
    end

    def standings_groups
      classificacao_rows.group_by { |row| [ row.category, row.group_key.to_s ] }.map do |(category, group_key), rows|
        StandingGroup.new(category: category, group_key: group_key, rows: rows)
      end.sort_by { |group| [ group.category.name.to_s.downcase, group.group_key.to_s.downcase ] }
    end

    def live_partidas
      partidas.select(&:live?)
    end

    def recent_results
      partidas.select(&:finished?).last(4)
    end

    def upcoming_partidas
      partidas.select(&:upcoming?).first(4)
    end

    def total_duplas
      duplas.size
    end

    def total_partidas
      partidas.size
    end

    def total_rodadas
      rodadas.size
    end

    def total_classificados
      standings_groups.sum { |group| group.rows.size }
    end

    def stats
      {
        total_maos: championship.tranca_partida_maos.count,
        total_finalizadas: partidas.count(&:finished?),
        total_mata_mata: knockout_partidas.size,
        total_rodadas_mata_mata: knockout_rounds.size,
        top_dupla: classificacao_rows.first&.tranca_dupla,
        top_points: classificacao_rows.first&.points.to_i
      }
    end

    private

    StandingGroup = Struct.new(:category, :group_key, :rows, keyword_init: true)
  end
end
