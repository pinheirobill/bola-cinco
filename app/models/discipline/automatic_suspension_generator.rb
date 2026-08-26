module Discipline
  class AutomaticSuspensionGenerator
    YELLOW_THRESHOLD = 3

    def initialize(championship:, yellow_threshold: YELLOW_THRESHOLD)
      @championship = championship
      @yellow_threshold = yellow_threshold
    end

    def call
      created = []
      created.concat(create_red_card_suspensions)
      created.concat(create_yellow_card_suspensions)
      created
    end

    private

    attr_reader :championship, :yellow_threshold

    def create_red_card_suspensions
      red_card_events.filter_map do |event|
        next if event.athlete.blank?

        build_suspension(
          source_id: "auto-red-card-#{event.id}",
          athlete: event.athlete,
          team: event.team || event.athlete.team,
          category: event.match.category,
          match_event: event,
          reason: "Cartão vermelho direto",
          starts_on: event.match.scheduled_on,
          source_data: {
            "kind" => event.kind,
            "match_event_id" => event.id,
            "match_id" => event.match_id
          }
        )
      end
    end

    def create_yellow_card_suspensions
      yellow_card_events.group_by(&:athlete_id).values.flat_map do |events|
        events.each_slice(yellow_threshold).filter_map do |slice|
          next if slice.size < yellow_threshold

          trigger_event = slice.last
          next if trigger_event.athlete.blank?

          build_suspension(
            source_id: "auto-yellow-threshold-#{trigger_event.id}",
            athlete: trigger_event.athlete,
            team: trigger_event.team || trigger_event.athlete.team,
            category: trigger_event.match.category,
            match_event: trigger_event,
            reason: "Acúmulo de cartões amarelos (#{yellow_threshold})",
            starts_on: trigger_event.match.scheduled_on,
            source_data: {
              "kind" => trigger_event.kind,
              "match_event_id" => trigger_event.id,
              "match_id" => trigger_event.match_id,
              "yellow_threshold" => yellow_threshold
            }
          )
        end
      end
    end

    def build_suspension(source_id:, athlete:, team:, category:, match_event:, reason:, starts_on:, source_data:)
      Suspension.find_or_initialize_by(source_id: source_id).tap do |suspension|
        suspension.assign_attributes(
          championship: championship,
          category: category,
          team: team,
          athlete: athlete,
          match_event: match_event,
          reason: reason,
          status: :ativa,
          automatic: true,
          matches_count: 1,
          starts_on: starts_on,
          source_data: source_data
        )
        suspension.save! if suspension.new_record? || suspension.changed?
      end
    end

    def ordered_match_events
      championship.match_events
        .includes(:athlete, :team, match: :category)
        .joins(:match)
        .order("matches.scheduled_on ASC, matches.id ASC, match_events.id ASC")
    end

    def yellow_card_events
      ordered_match_events.where(kind: "cartao_amarelo")
    end

    def red_card_events
      ordered_match_events.where(kind: "cartao_vermelho")
    end
  end
end
