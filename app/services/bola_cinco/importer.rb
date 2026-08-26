module BolaCinco
  class Importer
    def initialize(path:)
      @path = path
    end

    def call
      payload = JSON.parse(File.read(path))
      championship = upsert_championship(required_section(payload, "championship"))
      StandingRow.where(championship: championship).delete_all
      categories = upsert_categories(required_section(payload, "categories"), championship)
      entities = upsert_entities(required_section(payload, "entities"))
      teams = upsert_teams(required_section(payload, "teams"), entities, categories)
      upsert_athletes(payload.fetch("athletes", []), teams, categories)
      upsert_matches(required_section(payload, "matches"), championship, categories, teams)
      upsert_standings(required_section(payload, "standingsSnapshot"), championship, categories, teams)
      championship
    end

    private

    attr_reader :path

    def required_section(payload, key)
      payload.fetch(key) { raise ArgumentError, "Missing import payload section: #{key}" }
    end

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
        ChampionshipCategory.find_or_create_by!(championship: championship, category: record) do |membership|
          membership.source_id = "championship-category-#{championship.id}-#{record.id}"
        end
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

    def upsert_athletes(attrs, teams, categories)
      attrs.each do |item|
        record = Athlete.find_or_initialize_by(source_id: item.fetch("id"))
        record.update!(
          team: teams.fetch(item.fetch("teamId")),
          category: categories.fetch(item.fetch("categoryId")),
          user: User.find_by(id: item["userId"]),
          name: item.fetch("name"),
          birth_date: item["birthDate"],
          shirt_number: item["shirtNumber"],
          document: item["document"],
          photo_url: item["photoUrl"],
          cpf: item["cpf"],
          rg: item["rg"],
          birth_certificate: item["birthCertificate"],
          position: item["position"],
          cell_phone: item["cellPhone"],
          email: item["email"],
          passport: item["passport"],
          voter_id: item["voterId"],
          gender: item["gender"],
          documents_count: item["documentsCount"] || 0,
          registration_submitted_at: item["registrationSubmittedAt"],
          status: item["status"] || "pendente"
        )
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
        record[:venue] = item["venue"]
        record.save! if record.changed?
      end
    end

    def upsert_standings(attrs, championship, categories, teams)
      positions_by_category = Hash.new(0)

      attrs.each do |item|
        team = teams.fetch(item.fetch("teamId"))
        category = team.category
        positions_by_category[category.id] += 1
        record = StandingRow.find_or_initialize_by(championship: championship, category: team.category, team: team)
        record.update!(
          position: item["position"] || positions_by_category[category.id],
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
