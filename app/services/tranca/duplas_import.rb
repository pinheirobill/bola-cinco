require "digest"

module Tranca
  class DuplasImport
    class InvalidImport < StandardError; end

    attr_reader :championship, :category, :rows

    def initialize(championship:, category:, rows:)
      @championship, @category, @rows = championship, category, rows
      unless championship.tranca? && category.championship_id == championship.id &&
          category.championships.where.not(id: championship.id).none?
        raise InvalidImport, "Selecione uma categoria exclusiva deste campeonato de Tranca."
      end
      raise InvalidImport, "Quantidade de linhas inválida." unless rows.is_a?(Array) && rows.size.between?(1, DuplasSpreadsheet::MAX_ROWS)
    end

    def preview
      load_candidates
      seen = {}
      seen_names = {}
      repeated_names = rows.flat_map { |row| participant_names(row).map { |name| normalize(name) } }.tally
      rows.map do |row|
        names = participant_names(row)
        key = pair_key(names)
        error = row["file_error"].presence
        error ||= "Informe os dois participantes." if names.any?(&:blank?)
        error ||= "Os participantes precisam ser diferentes." if names.map { |name| normalize(name) }.uniq.size < 2
        error ||= "Cada nome deve ter até 150 caracteres." if names.any? { |name| name.length > 150 }
        error ||= "Nome da dupla deve ter até 310 caracteres." if row["name"].to_s.length > 310
        if seen[key] && error.blank?
          error = "Dupla repetida na planilha (linha #{seen[key]})."
        end
        seen[key] ||= row["line"]
        candidates = @teams_by_pair.fetch(key, [])
        current = candidates.select { |team| @current_team_ids.include?(team.id) }
        error ||= "Dupla já inscrita em outra categoria deste campeonato." if current.any? { |team| team.category_id != category.id }
        local = current.select { |team| team.category_id == category.id }
        pool = local.presence || candidates
        identities = pool.map { |team| [team.entity_id, team.athletes.map(&:id).sort] }.uniq
        error ||= "Há cadastros diferentes com esses nomes. Revise as duplas existentes antes de importar." if identities.size > 1 || local.size > 1
        team = pool.min_by(&:id)
        name = team&.name || row["name"].presence || names.join(" / ")
        error ||= "Já existe uma dupla com esse nome e outros integrantes. Revise o cadastro." if local.empty? && @current_names.include?(normalize(name))
        if seen_names[normalize(name)] && seen_names[normalize(name)] != key
          error ||= "Nome de dupla repetido com outros participantes nesta planilha."
        end
        seen_names[normalize(name)] ||= key if error.blank?
        error ||= "Esta dupla já está cadastrada. Confira a inscrição no cadastro existente." if @orphan_pairs.include?(key)
        warnings = []
        if names.any? { |participant| repeated_names[normalize(participant)].to_i > 1 }
          warnings << "Participante aparece em outra linha. Confira se é a mesma pessoa."
        end
        action = if error.present?
          "error"
        elsif local.any?
          team.registration_status_aprovada? ? "existing" : "approve"
        elsif team
          "reuse"
        else
          "create"
        end
        { line: row["line"], names: names, name: name, action: action, team: team, error: error, warnings: warnings }
      end
    end

    def call
      result = nil
      championship.with_lock do
        # Recheck after locking: another import may have registered the same pair since the preview.
        result = preview
        result.each do |entry|
          next if entry[:action] == "error"

          register!(entry)
        end
      end
      result
    end

    private

    def normalize(value)
      I18n.transliterate(value.to_s).downcase.squish
    end

    def participant_names(row)
      [row["participant_one"], row["participant_two"]].map { |name| name.to_s.squish }
    end

    def pair_key(names)
      names.map { |name| normalize(name) }.sort.join("\u001f")
    end

    def load_candidates
      @current_team_ids = Team.for_championship(championship).pluck(:id)
      @current_names = Team.where(id: @current_team_ids).pluck(:name).map { |name| normalize(name) }
      # Search only Tranca registrations; keep football teams out of name-based matching.
      teams = Team.joins(category: :championship).where(championships: { modality: "tranca" })
        .includes(:entity, :athletes).to_a
      @orphan_pairs = Tranca::Dupla.where.not(source_id: Team.select(:source_id)).includes(:athletes).filter_map do |dupla|
        names = dupla.athletes.map(&:name)
        names = dupla.name.split(/\s*\/\s*|\s+e\s+/i) if names.empty?
        pair_key(names) if names.size == 2
      end
      @teams_by_pair = teams.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |team, index|
        names = team.athletes.map(&:name)
        names = team.name.split(/\s*\/\s*|\s+e\s+/i) if names.empty?
        next unless names.size == 2

        index[pair_key(names)] << team
      end
    end

    def register!(entry)
      source = entry[:team]
      if %w[existing approve].include?(entry[:action])
        team = source
        unless team.registration_status_aprovada?
          team.tranca_import_synchronized = true
          team.approve!
        end
      else
        digest = Digest::SHA256.hexdigest(pair_key(entry[:names]))
        team = Team.find_or_initialize_by(source_id: "tranca-import-#{championship.id}-#{digest}")
        team.assign_attributes(category: category, entity: source&.entity || Entity.create!(
          source_id: "tranca-import-entity-#{championship.id}-#{digest}", name: entry[:name]
        ), name: entry[:name], short_name: source&.short_name, registration_status: :aprovada, finance_status: :pendente)
        team.tranca_import_synchronized = true
        team.save!
      end

      # The importer owns synchronization here; instance flags prevent callbacks
      # from repeating these same reads and writes after commit.
      dupla = Tranca::Dupla.find_or_initialize_by(source_id: team.source_id)
      new_dupla = dupla.new_record?
      dupla.update!(championship: championship, category: category, entity: team.entity,
        name: team.name, short_name: team.short_name, registration_status: :aprovada, status: :ativo)
      members = source&.athletes&.to_a || []
      members = team.athletes.to_a if members.empty? && !team.previously_new_record?
      if members.empty?
        members = entry[:names].map do |name|
          Athlete.create!(source_id: "tranca-import-athlete-#{SecureRandom.uuid}", name: name,
            team: team, category: category, status: :pendente, primary_team_link_imported: true)
        end
      end
      links = team.previously_new_record? ? {} : team.team_athletes.index_by(&:athlete_id)
      memberships = new_dupla ? {} : dupla.memberships.index_by(&:athlete_id)
      members.each do |athlete|
        link = links[athlete.id] || TeamAthlete.new(team: team, athlete: athlete)
        if link.new_record?
          link.source_id = "team-athlete-#{team.id}-#{athlete.id}"
          link.tranca_import_synchronized = true
          link.save!
        end
        next if memberships.key?(athlete.id)

        Tranca::DuplaMembership.create!(tranca_dupla: dupla, athlete: athlete, source_id: link.source_id)
      end
    end
  end
end
