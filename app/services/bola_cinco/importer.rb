module BolaCinco
  class Importer
    def initialize(path:)
      @path = path
    end

    def call
      payload = JSON.parse(File.read(path))
      championship = upsert_championship(payload.fetch("championship"))
      categories = upsert_categories(payload.fetch("categories"), championship)
      entities = upsert_entities(payload.fetch("entities"))
      teams = upsert_teams(payload.fetch("teams"), entities, categories)
      upsert_matches(payload.fetch("matches"), championship, categories, teams)
      upsert_standings(payload.fetch("standingsSnapshot"), championship, categories, teams)
      championship
    end

    private

    attr_reader :path

    def upsert_championship(attrs)
      Championship.find_or_initialize_by(source_id: attrs.fetch("id")).tap do |record|
        record.update!(
          name: attrs.fetch("name"),
          season: attrs.fetch("season"),
          status: attrs.fetch("status")
        )
      end
    end

    def upsert_categories(attrs, championship)
      attrs.each_with_object({}) do |item, hash|
        record = Category.find_or_initialize_by(source_id: item.fetch("id"))
        record.update!(
          championship: championship,
          name: item.fetch("name"),
          gender: item["gender"],
          min_birth_year: item["minBirthYear"],
          max_birth_year: item["maxBirthYear"],
          max_athletes: item["maxAthletes"]
        )
        hash[item.fetch("id")] = record
      end
    end

    def upsert_entities(attrs)
      attrs.each_with_object({}) do |item, hash|
        record = Entity.find_or_initialize_by(source_id: item.fetch("id"))
        record.update!(
          name: item.fetch("name"),
          responsible: item["responsible"],
          phone: item["phone"],
          whatsapp: item["whatsapp"],
          email: item["email"],
          city: item["city"],
          notes: item["notes"]
        )
        hash[item.fetch("id")] = record
      end
    end

    def upsert_teams(attrs, entities, categories)
      attrs.each_with_object({}) do |item, hash|
        record = Team.find_or_initialize_by(source_id: item.fetch("id"))
        record.update!(
          entity: entities.fetch(item.fetch("entityId")),
          category: categories.fetch(item.fetch("categoryId")),
          name: item.fetch("name"),
          short_name: item["shortName"],
          registration_status: item.dig("registration", "status") || "pendente",
          finance_status: item.dig("finance", "status") || "pendente",
          group_key: item["group"]
        )
        hash[item.fetch("id")] = record
      end
    end

    def upsert_matches(attrs, championship, categories, teams)
      attrs.each do |item|
        record = Match.find_or_initialize_by(source_id: item.fetch("id"))
        record.update!(
          championship: championship,
          category: categories.fetch(item.fetch("categoryId")),
          code: item.fetch("code"),
          phase: item.fetch("phase"),
          group_key: item["group"],
          round_number: item["round"],
          scheduled_on: item["date"],
          scheduled_time: item["time"],
          venue: item["venue"],
          team_a: teams[item["teamAId"]],
          team_b: teams[item["teamBId"]],
          source_a: item["sourceA"],
          source_b: item["sourceB"],
          score_a: item["scoreA"],
          score_b: item["scoreB"],
          status: item.fetch("status"),
          wo: item["wo"],
          winner: teams[item["winnerId"]],
          penalties_a: item["penaltiesA"],
          penalties_b: item["penaltiesB"],
          decision: item["decision"],
          scorers: item["scorers"] || {},
          highlight_videos: item["highlightVideos"] || item["highlight_videos"] || [],
          source_data: item["_source"] || {}
        )
      end
    end

    def upsert_standings(attrs, championship, categories, teams)
      attrs.each_with_index do |item, index|
        team = teams.fetch(item.fetch("teamId"))
        record = StandingRow.find_or_initialize_by(championship: championship, category: team.category, team: team)
        record.update!(
          position: item["position"] || index + 1,
          played: item.fetch("played"),
          wins: item.fetch("wins"),
          draws: item.fetch("draws"),
          losses: item.fetch("losses"),
          goals_for: item.fetch("goalsFor"),
          goals_against: item.fetch("goalsAgainst"),
          goal_diff: item.fetch("goalDiff"),
          points: item["points"] || 0,
          qualified: item["qualified"]
        )
      end
    end
  end
end
