require "digest"

module BolaCinco
  class TeamRosterImport
    class InvalidImport < StandardError; end

    attr_reader :championship, :category, :rows

    def initialize(championship:, category:, rows:)
      @championship = championship
      @category = category
      @rows = rows

      unless championship.is_a?(Championship) && category.is_a?(Category) && category.championship_id == championship.id
        raise InvalidImport, "Selecione uma categoria deste campeonato."
      end
      raise InvalidImport, "Quantidade de linhas inválida." unless rows.is_a?(Array) && rows.any? && rows.size <= TeamRosterSpreadsheet::MAX_ROWS
    end

    def preview
      load_existing_athletes
      grouped_rows.map do |_team_name_key, team_rows|
        preview_team(team_rows)
      end
    end

    def call
      result = nil
      championship.with_lock do
        result = preview
        errors = result.select { |entry| entry[:error].present? }
        raise InvalidImport, errors.map { |entry| "Linha #{entry[:line]}: #{entry[:error]}" }.join(" · ") if errors.any?

        result.each { |entry| register_team!(entry) }
      end
      result
    end

    private

    def grouped_rows
      rows.group_by { |row| normalize(row["team_name"]) }
    end

    def preview_team(team_rows)
      first_row = team_rows.first
      team_name = first_row["team_name"].to_s.squish
      team_signature = team_signature_for(team_name, team_rows)
      team_source_id = team_source_id_for(team_signature)
      team = Team.find_by(source_id: team_source_id)
      team_error = nil
      team_error ||= "Informe o nome da equipe." if team_name.blank?

      athletes = team_rows.map do |row|
        preview_athlete(team_signature, row)
      end
      team_error ||= athletes.filter_map { |entry| entry[:error] }.first

      {
        line: first_row["line"],
        team_name: team_name,
        team_signature: team_signature,
        team_source_id: team_source_id,
        action: team.present? ? "reuse" : "create",
        team: team,
        athletes: athletes,
        reused_athletes: athletes.count { |entry| entry[:action] == "reuse" },
        created_athletes: athletes.count { |entry| entry[:action] == "create" },
        error: team_error
      }
    end

    def preview_athlete(team_signature, row)
      athlete_name = row["athlete_name"].to_s.squish
      rg = row["rg"].to_s.squish
      cpf = row["cpf"].to_s.squish
      shirt_number = row["shirt_number"].to_s.squish
      birth_date = parse_birth_date(row["birth_date"])
      error = row["file_error"].presence
      error ||= "Informe o nome do atleta." if athlete_name.blank?

      athlete = athlete_for_row(row)
      action = athlete.present? ? "reuse" : "create"
      {
        line: row["line"],
        athlete_name: athlete_name,
        rg: rg,
        cpf: cpf,
        shirt_number: shirt_number,
        birth_date: birth_date,
        team_signature: team_signature,
        athlete: athlete,
        action: action,
        error: error
      }
    end

    def register_team!(entry)
      team = Team.find_or_initialize_by(source_id: entry[:team_source_id])
      team.assign_attributes(
        entity: entity_for(entry),
        category: category,
        name: entry[:team_name],
        short_name: entry[:team_name].truncate(40),
        registration_status: :aprovada,
        finance_status: :pendente
      )
      team.save!

      entry[:athletes].each do |athlete_entry|
        register_athlete!(team, athlete_entry)
      end
    end

    def register_athlete!(team, entry)
      athlete = entry[:athlete] || Athlete.find_or_initialize_by(source_id: athlete_source_id(team.source_id, entry))
      athlete.assign_attributes(
        team: team,
        category: category,
        name: entry[:athlete_name],
        shirt_number: entry[:shirt_number].presence || athlete.shirt_number,
        rg: athlete.rg.presence || entry[:rg],
        cpf: athlete.cpf.presence || entry[:cpf],
        birth_date: athlete.birth_date || entry[:birth_date],
        status: athlete.status || :pendente,
        registration_submitted_at: athlete.registration_submitted_at || Time.current
      )
      athlete.primary_team_link_imported = true if athlete.new_record?
      athlete.save!

      TeamAthlete.find_or_create_by!(team: team, athlete: athlete) do |link|
        link.source_id = "team-athlete-#{team.id}-#{athlete.id}"
      end

      athlete
    end

    def athlete_for_row(row)
      if row["rg"].present?
        normalized = normalize_document(row["rg"])
        @existing_athletes.find { |athlete| normalize_document(athlete.rg) == normalized }
      end
    end

    def load_existing_athletes
      @existing_athletes ||= Athlete.where.not(rg: [ nil, "" ]).includes(:team, :category).to_a
    end

    def entity_for(entry)
      entity = Entity.find_or_initialize_by(source_id: entity_source_id_for(entry[:team_signature]))
      entity.name = entry[:team_name]
      entity.save!
      entity
    end

    def team_signature_for(team_name, team_rows)
      payload = [
        normalize(team_name),
        *team_rows.map do |row|
          [
            normalize(row["athlete_name"]),
            normalize_document(row["rg"]),
            normalize_document(row["cpf"]),
            row["shirt_number"].to_s.strip,
            parse_birth_date(row["birth_date"])&.iso8601.to_s
          ].join("\u001f")
        end.sort
      ].join("\u001e")
      Digest::SHA256.hexdigest(payload)
    end

    def team_source_id_for(team_signature)
      "championship-team-import-#{championship.id}-#{team_signature}"
    end

    def entity_source_id_for(team_signature)
      "championship-team-import-entity-#{championship.id}-#{team_signature}"
    end

    def athlete_source_id(team_source_id, entry)
      digest = Digest::SHA256.hexdigest([
        team_source_id,
        normalize(entry[:athlete_name]),
        normalize_document(entry[:rg]),
        normalize_document(entry[:cpf]),
        entry[:birth_date].to_s,
        entry[:shirt_number].to_s
      ].join("\u001f"))
      "championship-team-import-athlete-#{digest}"
    end

    def normalize(value)
      I18n.transliterate(value.to_s).downcase.squish
    end

    def normalize_document(value)
      value.to_s.strip.gsub(/[^0-9a-z]/i, "").downcase
    end

    def parse_birth_date(value)
      text = value.to_s.strip
      return nil if text.blank?

      begin
        if text.match?(/\A\d+\z/)
          Date.new(1899, 12, 30) + text.to_i
        else
          Date.strptime(text, "%d/%m/%Y")
        end
      rescue ArgumentError, TypeError
        begin
          Date.parse(text)
        rescue ArgumentError, TypeError
          nil
        end
      end
    end
  end
end
