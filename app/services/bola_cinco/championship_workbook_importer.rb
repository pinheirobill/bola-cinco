require "json"
require "date"
require "tempfile"
require "zip"
require "nokogiri"

module BolaCinco
  class ChampionshipWorkbookImporter
    CATEGORY_SPECS = {
      "SUB 08" => { name: "Sub 08", source_id: "sub-08", min_birth_year: 2018, max_birth_year: 2018 },
      "SUB 09" => { name: "Sub 09", source_id: "sub-09", min_birth_year: 2017, max_birth_year: 2017 },
      "SUB 10" => { name: "Sub 10", source_id: "sub-10", min_birth_year: 2016, max_birth_year: 2016 },
      "SUB 11" => { name: "Sub 11", source_id: "sub-11", min_birth_year: 2015, max_birth_year: 2015 },
      "SUB 12" => { name: "Sub 12", source_id: "sub-12", min_birth_year: 2014, max_birth_year: 2014 },
      "SUB 13" => { name: "Sub 13", source_id: "sub-13", min_birth_year: 2013, max_birth_year: 2013 }
    }.freeze

    TEAM_ALIASES = {
      "ACESOS ACADEMY" => "ACADEMY ACESOS",
      "COL. J. SÃO PAULO TREMEMBÉ" => "COL. J. S. PAULO TREMEMBÉ",
      "L.B.V" => "L.B.V.",
      "L.B.V  " => "L.B.V."
    }.freeze

    KNOWN_TEAM_NAMES = [
      "ACADEMY ACESOS",
      "COL. ANGLO MORUMBI",
      "COL. BEIT YAACOV",
      "COL. IAVNE",
      "COL. J. S. PAULO TREMEMBÉ",
      "COL. PENTÁGONO PERDIZES",
      "COOPERCOTIA",
      "L.B.V.",
      "TÊNIS CLUBE PAULISTA",
      "W.P. SPORTS"
    ].freeze

    VENUE_ALIASES = {
      "COL. J. SÃO PAULO RECANTO" => "COL. J. S. P. RECANTO"
    }.freeze

    CATEGORY_TABS = {
      "SUB 08 - 06 EQUIPES" => "SUB 08",
      "SUB 09 - 06 EQUIPES" => "SUB 09",
      "SUB 10 - 08 EQUIPES" => "SUB 10",
      "SUB 11 - 07 EQUIPES" => "SUB 11",
      "SUB 12 - 06 EQUIPES" => "SUB 12",
      "SUB 13 - 04 EQUIPES" => "SUB 13"
    }.freeze

    def initialize(path:)
      @path = path
    end

    def call
      parsed = parse_workbook

      payload = {
        "championship" => parsed.fetch(:championship),
        "categories" => parsed.fetch(:categories),
        "entities" => parsed.fetch(:entities),
        "teams" => parsed.fetch(:teams),
        "athletes" => [],
        "matches" => parsed.fetch(:matches),
        "standingsSnapshot" => []
      }

      Tempfile.create(["bola-cinco-workbook-import", ".json"]) do |file|
        file.write(JSON.pretty_generate(payload))
        file.flush

        championship = Importer.new(path: file.path).call
        apply_configuration!(championship, parsed)
        championship.rebuild_standings!
        championship
      end
    end

    private

    attr_reader :path

    def apply_configuration!(championship, parsed)
      championship.update!(
        status: parsed[:championship].fetch("status"),
        modality: :football,
        notes: parsed[:notes],
        rules: championship.default_rules.deep_merge(parsed[:rules]),
        format: championship.default_format.merge(parsed[:format]),
        scoring: championship.default_scoring.merge(parsed[:scoring])
      )

      venues_by_name = parsed[:venues].each_with_object({}) do |venue_attrs, hash|
        venue = championship.venues.find_or_initialize_by(source_id: venue_attrs.fetch("id"))
        venue.update!(
          name: venue_attrs.fetch("name"),
          short_name: venue_attrs["shortName"],
          address: venue_attrs["address"],
          city: venue_attrs["city"],
          notes: venue_attrs["notes"],
          status: venue_attrs["status"] || :ativo
        )
        hash[venue.name] = venue
      end

      championship.matches.includes(:venue).find_each do |match|
        venue = venues_by_name[match.venue_name]
        next if venue.blank?

        match.update_columns(venue_id: venue.id, updated_at: Time.current)
      end
    end

    def parse_workbook
      rows_by_sheet = sheet_rows

      categories = parse_categories
      entities = {}
      teams = {}
      venues = []
      matches = parse_matches(rows_by_sheet.fetch("PROGRAMAÇÃO 1º SEMESTRE "), teams, entities, venues)

      {
        championship: championship_payload,
        categories: categories,
        entities: entities.values.sort_by { |item| item.fetch("name") },
        teams: teams.values.sort_by { |item| [item.fetch("categoryId"), item.fetch("name")] },
        venues: venues.uniq { |item| item.fetch("id") }.sort_by { |item| item.fetch("name") },
        matches: matches,
        rules: rules_payload,
        format: format_payload(teams.values, categories),
        scoring: scoring_payload,
        notes: notes_payload
      }
    end

    def championship_payload
      {
        "id" => "copa-bola-5-37-interescolas-de-futsal-2026",
        "name" => "COPA BOLA 5 - 37ª INTERESCOLAS DE FUTSAL - 2026",
        "season" => 2026,
        "status" => "em_andamento"
      }
    end

    def rules_payload
      {
        "registration" => {
          "max_athletes_per_team" => 25,
          "max_staff_members_per_team" => 5,
          "athlete_actions" => {
            "allow_register" => true,
            "allow_edit" => true,
            "allow_remove" => false
          },
          "team_signups" => {
            "enabled" => true,
            "status" => "inscricoes_abertas"
          },
          "athlete_form" => {
            "apelido" => "obrigatorio",
            "foto" => "informar",
            "cpf" => "obrigatorio",
            "rg" => "informar",
            "certidao_nascimento" => "informar",
            "data_nascimento" => "obrigatorio",
            "posicao" => "obrigatorio",
            "numero_camisa" => "obrigatorio",
            "celular" => "obrigatorio",
            "email" => "obrigatorio",
            "passaporte" => "informar",
            "titulo_eleitor" => "informar",
            "genero" => "obrigatorio",
            "documentos_anexo" => "informar"
          },
          "printed_summary_field" => "cpf"
        }
      }
    end

    def format_payload(teams, _categories)
      {
        "mode" => "pontuacao",
        "teamCount" => teams.size,
        "groupCount" => 1,
        "qualifiedPerGroup" => 0,
        "matchesPerOpponent" => 1
      }
    end

    def scoring_payload
      {
        "win" => 3,
        "draw" => 1,
        "loss" => 0,
        "wo" => -1,
        "woScore" => 2,
        "qualifiedPerGroup" => 0,
        "tiebreakers" => %w[vitorias saldo_gols gols_pro confronto_direto sorteio]
      }
    end

    def notes_payload
      <<~TEXT.squish
        Regulamento importado da aba Regulamento.
        Chave única por categoria, jogos da programação importados com placar,
        limite de 25 atletas por equipe, vitória 3 pontos, empate 1, derrota 0 e WO -1.
      TEXT
    end

    def parse_categories
      CATEGORY_SPECS.map do |_tab_name, spec|
        {
          "id" => spec.fetch(:source_id),
          "name" => spec.fetch(:name),
          "gender" => "masculino",
          "minBirthYear" => spec.fetch(:min_birth_year),
          "maxBirthYear" => spec.fetch(:max_birth_year),
          "maxAthletes" => 25
        }
      end
    end

    def parse_matches(rows, teams, entities, venues)
      current_date = nil
      current_venue_name = nil
      current_venue_address = nil
      matches = []

      rows.each_with_index do |row, index|
        header = row.values.compact.join(" ").squish
        if header.include?("Local:") && !header.casecmp("Horário").zero?
          header_date = parse_header_date(header)
          venue_name, venue_address = parse_header_venue(header)
          if header_date.present? && venue_name.present?
            current_date = header_date
            current_venue_name = venue_name
            current_venue_address = venue_address
            register_venue(current_venue_name, current_venue_address, venues)
          end
          next
        end

        next if row.fetch("A", "").to_s.squish.casecmp("Horário").zero?
        next if row.fetch("B", "").to_s.squish.casecmp("Horário").zero?
        next if row.fetch("C", "").to_s.squish.casecmp("Horário").zero?

        time = [row["A"], row["B"]].compact.map(&:to_s).map(&:squish).find { |value| value.match?(/\A\d{1,2}H\d{2}\z/) }
        category_label = [row["A"], row["B"], row["C"]].compact.map(&:to_s).map(&:squish).find { |value| value.match?(/\ASUB\s*0?\d+\z/i) }
        team_a_name = canonical_team_name(row["D"])
        team_b_name = canonical_team_name(row["H"])
        score_a = parse_score(row["E"])
        score_b = parse_score(row["G"])
        match_status = score_a.present? && score_b.present? ? "finalizado" : "agendado"

        next if time.blank? || category_label.blank? || team_a_name.blank? || team_b_name.blank?
        next unless known_team_name?(team_a_name) && known_team_name?(team_b_name)
        next if current_date.blank? || current_venue_name.blank?

        category = category_spec_for(category_label)
        team_a = team_for!(teams, entities, category, team_a_name)
        team_b = team_for!(teams, entities, category, team_b_name)
        source_id = match_source_id(current_date, time, category.fetch(:name), team_a_name, team_b_name)

        matches << {
          "id" => source_id,
          "categoryId" => category.fetch(:source_id),
          "code" => match_code_for(current_date, time, category.fetch(:name), team_a_name, team_b_name),
          "phase" => "classificatoria",
          "round" => index + 1,
          "date" => current_date.iso8601,
          "time" => time,
          "teamAId" => team_a.fetch("id"),
          "teamBId" => team_b.fetch("id"),
          "sourceA" => {
            "name" => team_a_name
          },
          "sourceB" => {
            "name" => team_b_name
          },
          "scoreA" => score_a,
          "scoreB" => score_b,
          "status" => match_status,
          "venue" => current_venue_name,
          "_source" => {
            "sheet" => "PROGRAMAÇÃO 1º SEMESTRE ",
            "row" => row["__row_number__"],
            "header" => header,
            "venueAddress" => current_venue_address
          }
        }
      end

      matches
    end

    def team_for!(teams, entities, category, team_name)
      team_key = [category.fetch(:source_id), team_name].join(":")
      teams[team_key] ||= begin
        entity = entity_for!(entities, team_name)
        {
          "id" => team_source_id(category.fetch(:source_id), entity.fetch("id")),
          "entityId" => entity.fetch("id"),
          "categoryId" => category.fetch(:source_id),
          "name" => team_name,
          "shortName" => team_name,
          "registration" => {
            "status" => "aprovada"
          },
          "finance" => {
            "status" => "pendente"
          }
        }
      end
    end

    def entity_for!(entities, team_name)
      canonical = entity_name_for(team_name)
      entities[canonical] ||= {
        "id" => entity_source_id(canonical),
        "name" => canonical
      }
    end

    def register_venue(name, address, venues)
      return if name.blank?

      name = canonical_venue_name(name)
      venues << {
        "id" => venue_source_id(name),
        "name" => name,
        "shortName" => name,
        "address" => address,
        "city" => infer_city(address),
        "notes" => address,
        "status" => "ativo"
      }
    end

    def parse_header_date(header)
      match = header.match(/(\d{2}\/\d{2}\/\d{2,4})/)
      return nil if match.blank?

      text = match[1]
      Date.strptime(text, text.length == 8 ? "%d/%m/%y" : "%d/%m/%Y")
    end

    def parse_header_venue(header)
      match = header.match(/Local:\s*(.+?)(?:\s*-\s*|\s+)End(?:ere[cç]o|\.?)[: ]\s*(.+)\z/i)
      return [nil, nil] if match.blank?

      [canonical_venue_name(match[1].squish), match[2].squish]
    end

    def parse_score(value)
      text = value.to_s.squish
      return nil if text.blank?
      return nil unless text.match?(/\A\d+(?:\.\d+)?\z/)

      numeric = text.to_f
      numeric == numeric.to_i ? numeric.to_i : numeric
    end

    def category_spec_for(label)
      key = label.to_s.upcase.gsub(/\s+/, " ").strip
      spec = CATEGORY_SPECS.fetch(key)

      {
        source_id: spec.fetch(:source_id),
        name: spec.fetch(:name)
      }
    end

    def canonical_team_name(name)
      normalized = name.to_s.squish
      TEAM_ALIASES.fetch(normalized, normalized)
    end

    def canonical_venue_name(name)
      normalized = name.to_s.squish
      VENUE_ALIASES.fetch(normalized, normalized)
    end

    def known_team_name?(name)
      KNOWN_TEAM_NAMES.include?(name)
    end

    def entity_name_for(team_name)
      case team_name
      when "ACADEMY ACESOS"
        "Academy Acesos"
      when "COL. ANGLO MORUMBI"
        "Col. Anglo Morumbi"
      when "COL. BEIT YAACOV"
        "Col. Beit Yaacov"
      when "COL. IAVNE"
        "Col. Iavne"
      when "COL. J. S. PAULO TREMEMBÉ"
        "Col. J. S. Paulo Tremembé"
      when "COL. PENTÁGONO PERDIZES"
        "Col. Pentágono Perdizes"
      when "COOPERCOTIA"
        "Coopercotia"
      when "L.B.V."
        "L.B.V."
      when "TÊNIS CLUBE PAULISTA"
        "Tênis Clube Paulista"
      when "W.P. SPORTS"
        "W.P. Sports"
      else
        team_name.to_s.titleize
      end
    end

    def team_source_id(category_source_id, entity_source_id)
      "team-#{category_source_id}-#{entity_source_id}"
    end

    def entity_source_id(name)
      "entity-#{name.parameterize}"
    end

    def venue_source_id(name)
      "venue-#{name.parameterize}"
    end

    def match_source_id(date, time, category_name, team_a_name, team_b_name)
      [
        "match",
        date.strftime("%Y%m%d"),
        time.downcase,
        category_name,
        team_a_name,
        team_b_name
      ].join("-").parameterize
    end

    def match_code_for(date, time, category_name, team_a_name, team_b_name)
      [
        "COPA",
        date.strftime("%Y%m%d"),
        time,
        category_name,
        team_a_name,
        team_b_name
      ].join("-").parameterize.upcase
    end

    def infer_city(address)
      return nil if address.blank?

      tail = address.split("-").last.to_s.squish
      tail.presence
    end

    def sheet_rows
      @sheet_rows ||= begin
        workbook_map = workbook_sheet_map
        workbook_map.each_with_object({}) do |(sheet_name, target), hash|
          hash[sheet_name] = extract_rows(target)
        end
      end
    end

    def workbook_sheet_map
      @workbook_sheet_map ||= begin
        workbook = xml_for("xl/workbook.xml")
        workbook.remove_namespaces!
        rels = xml_for("xl/_rels/workbook.xml.rels")
        rels.remove_namespaces!

        relation_targets = rels.xpath("//Relationship").each_with_object({}) do |relationship, hash|
          hash[relationship["Id"]] = relationship["Target"]
        end

        workbook.xpath("//sheet").each_with_object({}) do |sheet, hash|
          hash[sheet["name"]] = "xl/#{relation_targets.fetch(sheet["id"])}"
        end
      end
    end

    def extract_rows(target)
      doc = xml_for(target)
      doc.remove_namespaces!

      doc.xpath("//sheetData/row").map do |row|
        row.xpath("c").each_with_object({ "__row_number__" => row["r"] }) do |cell, hash|
          ref = cell["r"].to_s
          column = ref[/\A[A-Z]+/]
          hash[column] = cell_value(cell)
        end
      end
    end

    def cell_value(cell)
      text = cell["t"].to_s
      if text == "s"
        shared_strings.fetch(cell.xpath("./v").text.to_i, "")
      elsif text == "inlineStr"
        cell.xpath(".//t").map(&:text).join
      else
        cell.xpath("./v").text
      end
    end

    def xml_for(target)
      @xml_docs ||= {}
      @xml_docs[target] ||= Zip::File.open(path) do |zip|
        Nokogiri::XML(zip.read(target))
      end
    end

    def shared_strings
      @shared_strings ||= begin
        doc = xml_for("xl/sharedStrings.xml")
        doc.remove_namespaces!
        doc.xpath("//sst/si").map { |node| node.xpath(".//t").map(&:text).join }
      rescue Zip::Error
        []
      end
    end
  end
end
