require "json"
require "date"
require "tempfile"
require "zip"
require "nokogiri"

module BolaCinco
  class TrancaWorkbookImporter
    FIRST_PHASE_GROUPS = %w[A B C D E F G H I].freeze
    SECOND_PHASE_GROUPS = %w[1 2 3 4].freeze

    def initialize(path:)
      @path = path
    end

    def call
      parsed = parse_workbook

      championship = prepare_championship!(parsed.fetch(:championship))
      payload = build_payload(parsed)

      Tempfile.create(["tranca-workbook-import", ".json"]) do |file|
        file.write(JSON.pretty_generate(payload))
        file.flush

        championship = Importer.new(path: file.path).call
        apply_configuration!(championship, parsed)
        rebuild_tranca_classificacao!(championship)
        championship
      end
    end

    private

    attr_reader :path

    def prepare_championship!(attrs)
      Championship.find_or_initialize_by(source_id: attrs.fetch("id")).tap do |record|
        record.update!(
          name: attrs.fetch("name"),
          season: attrs.fetch("season"),
          status: attrs.fetch("status"),
          modality: :tranca
        )
      end
    end

    def build_payload(parsed)
      {
        "championship" => parsed.fetch(:championship),
        "categories" => parsed.fetch(:categories),
        "entities" => parsed.fetch(:entities),
        "teams" => parsed.fetch(:teams),
        "athletes" => [],
        "matches" => parsed.fetch(:matches),
        "standingsSnapshot" => []
      }
    end

    def apply_configuration!(championship, parsed)
      championship.update!(
        modality: :tranca,
        status: parsed[:championship].fetch("status"),
        notes: parsed[:notes],
        rules: championship.default_rules.deep_merge(parsed[:rules]),
        format: championship.default_format.merge(parsed[:format]),
        scoring: championship.default_scoring.merge(parsed[:scoring])
      )

      championship.tranca_setting&.destroy!
      championship.create_tranca_setting!(
        source_id: tranca_setting_source_id(championship),
        rules: parsed[:rules],
        scoring: parsed[:scoring],
        format: parsed[:format]
      )
    end

    def rebuild_tranca_classificacao!(championship)
      Tranca::CompetitionFlow.new(championship).rebuild_classificacao!
      championship.tranca_classificacao_rows.where.not(group_key: FIRST_PHASE_GROUPS + SECOND_PHASE_GROUPS).delete_all
    end

    def parse_workbook
      rows_by_sheet = sheet_rows

      first_phase = parse_group_phase(
        rows: rows_by_sheet.fetch("TRANCA 1a Fase - 48 duplas"),
        allowed_group_keys: FIRST_PHASE_GROUPS,
        phase: "classificatoria"
      )

      second_phase = parse_second_phase(rows_by_sheet.fetch("2ª FASE - 16 DUPLAS"))

      matches = (first_phase.fetch(:matches) + second_phase.fetch(:matches)).sort_by do |item|
        [
          phase_sort_key(item["phase"]),
          group_sort_key(item["group"]),
          item["round"].to_i,
          item["code"].to_s
        ]
      end

      {
        championship: championship_payload,
        categories: [category_payload],
        entities: first_phase.fetch(:entities),
        teams: first_phase.fetch(:teams),
        matches: matches,
        rules: rules_payload,
        format: format_payload(first_phase.fetch(:teams).size),
        scoring: scoring_payload,
        notes: notes_payload
      }
    end

    def parse_group_phase(rows:, allowed_group_keys:, phase:)
      current_group_key = nil
      round_numbers_by_group = Hash.new(0)
      teams = {}
      entities = {}
      matches = []

      rows.each do |row|
        current_group_key = header_group_key(row) if header_group_key(row).present? && allowed_group_keys.include?(header_group_key(row))

        code = row["A"].to_s.squish
        next unless code.match?(/\AJG\b/i)
        next unless current_group_key.present? && allowed_group_keys.include?(current_group_key)

        team_a_name = canonical_team_name(row["C"])
        team_b_name = canonical_team_name(row["I"])
        next if team_a_name.blank? || team_b_name.blank?
        next if placeholder_team_name?(team_a_name) || placeholder_team_name?(team_b_name)

        register_team!(teams, entities, current_group_key, team_a_name)
        register_team!(teams, entities, current_group_key, team_b_name)

        round_numbers_by_group[current_group_key] += 1
        matches << match_payload_for(
          code: code,
          phase: phase,
          group_key: current_group_key,
          round_number: round_numbers_by_group[current_group_key],
          row: row,
          team_a_name: team_a_name,
          team_b_name: team_b_name
        )
      end

      {
        teams: teams.values.sort_by { |item| [item.fetch("group"), item.fetch("name")] },
        entities: entities.values.sort_by { |item| item.fetch("name") },
        matches: matches
      }
    end

    def parse_second_phase(rows)
      current_group_key = nil
      round_numbers_by_group = Hash.new(0)
      matches = []

      rows.each do |row|
        header_key = header_group_key(row)
        current_group_key = header_key if header_key.present? && SECOND_PHASE_GROUPS.include?(header_key)

        code = row["A"].to_s.squish
        next if code.blank?

        if code.match?(/\AJG\b/i)
          next unless current_group_key.present? && SECOND_PHASE_GROUPS.include?(current_group_key)

          team_a_name = canonical_team_name(row["C"])
          team_b_name = canonical_team_name(row["I"])
          next if team_a_name.blank? || team_b_name.blank?
          next if placeholder_team_name?(team_a_name) || placeholder_team_name?(team_b_name)

          round_numbers_by_group[current_group_key] += 1
          matches << match_payload_for(
            code: code,
            phase: "classificatoria",
            group_key: current_group_key,
            round_number: round_numbers_by_group[current_group_key],
            row: row,
            team_a_name: team_a_name,
            team_b_name: team_b_name
          )
          next
        end

        next unless code.match?(/\A(?:QF|SF|FINAL|3º\/4º)/i)

        group_key = knockout_group_key_for(code)
        team_a_name = canonical_team_name(row["C"])
        team_b_name = canonical_team_name(row["I"])
        next if team_a_name.blank? || team_b_name.blank?

        round_number = knockout_round_number_for(code)
        matches << match_payload_for(
          code: code,
          phase: "mata_mata",
          group_key: group_key,
          round_number: round_number,
          row: row,
          team_a_name: team_a_name,
          team_b_name: team_b_name
        )
      end

      {
        matches: matches
      }
    end

    def match_payload_for(code:, phase:, group_key:, round_number:, row:, team_a_name:, team_b_name:)
      score_a = parse_score(row["D"])
      score_b = parse_score(row["H"])
      source_id = match_source_id(code, phase, group_key, round_number, team_a_name, team_b_name)
      winner_name = winner_name_for(team_a_name, team_b_name, score_a, score_b)

      {
        "id" => source_id,
        "categoryId" => category_source_id,
        "code" => code,
        "phase" => phase,
        "group" => group_key,
        "round" => round_number,
        "date" => nil,
        "time" => nil,
        "teamAId" => team_source_id(team_a_name),
        "teamBId" => team_source_id(team_b_name),
        "sourceA" => { "name" => team_a_name },
        "sourceB" => { "name" => team_b_name },
        "scoreA" => score_a,
        "scoreB" => score_b,
        "status" => "finalizado",
        "venue" => "Mesa #{row['B'].to_s.squish.presence || round_number}",
        "winnerId" => winner_name.present? ? team_source_id(winner_name) : nil,
        "_source" => {
          "sheet" => row["__sheet_name__"],
          "row" => row["__row_number__"],
          "rawCode" => row["A"].to_s.squish
        }
      }
    end

    def register_team!(teams, entities, group_key, team_name)
      team_id = team_source_id(team_name)
      teams[team_id] ||= {
        "id" => team_id,
        "entityId" => entity_source_id(team_name),
        "categoryId" => category_source_id,
        "group" => group_key,
        "name" => team_name,
        "shortName" => team_name,
        "registration" => {
          "status" => "aprovada"
        },
        "finance" => {
          "status" => "pendente"
        }
      }

      entities[entity_source_id(team_name)] ||= {
        "id" => entity_source_id(team_name),
        "name" => team_name
      }
    end

    def championship_payload
      {
        "id" => championship_source_id,
        "name" => "11º TORNEIO DE TRANCA E.C. PINHEIROS 2026",
        "season" => 2026,
        "status" => "em_andamento"
      }
    end

    def category_payload
      {
        "id" => category_source_id,
        "name" => "11º TORNEIO DE TRANCA E.C. PINHEIROS 2026",
        "gender" => "misto",
        "maxAthletes" => 2
      }
    end

    def rules_payload
      {
        "registration" => {
          "max_athletes_per_team" => 2,
          "max_staff_members_per_team" => 2,
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
            "cpf" => "informar",
            "rg" => "informar",
            "certidao_nascimento" => "informar",
            "data_nascimento" => "informar",
            "posicao" => "informar",
            "numero_camisa" => "informar",
            "celular" => "informar",
            "email" => "informar",
            "passaporte" => "informar",
            "titulo_eleitor" => "informar",
            "genero" => "informar",
            "documentos_anexo" => "informar"
          },
          "printed_summary_field" => "cpf"
        }
      }
    end

    def format_payload(team_count)
      {
        "mode" => "grupos_mata_mata",
        "teamCount" => team_count,
        "groupCount" => 9,
        "qualifiedPerGroup" => 2,
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
        "qualifiedPerGroup" => 2,
        "tiebreakers" => %w[vitorias saldo_gols gols_pro confronto_direto menos_gols_sofridos sorteio]
      }
    end

    def notes_payload
      <<~TEXT.squish
        Regulamento e chaves importados do Excel.
        Fase 1 com 9 grupos (A-I), 2 classificados por chave.
        Fase 2 com 4 grupos (1-4), seguida de quartas, semifinais, final e disputa de 3º/4º.
        Critérios de desempate: vitórias, pontuação e saldo de pontos.
      TEXT
    end

    def parse_score(value)
      text = value.to_s.squish
      return nil if text.blank?
      return nil unless text.match?(/\A-?\d+(?:\.\d+)?\z/)

      numeric = text.to_f
      numeric == numeric.to_i ? numeric.to_i : numeric
    end

    def canonical_team_name(name)
      normalized = name.to_s.squish
      return nil if normalized.blank?

      TEAM_ALIASES.fetch(normalized, normalized)
    end

    def placeholder_team_name?(name)
      normalized = name.to_s.squish.upcase
      normalized.match?(/\A(?:\d+|PTS|CHAVE\s+\d+\s+J|.+FOI PRA CHAVE.+|.+N[AÃ]O VEIO.+)\z/)
    end

    def winner_name_for(team_a_name, team_b_name, score_a, score_b)
      return nil if score_a.blank? || score_b.blank?
      return team_a_name if score_a.to_f > score_b.to_f
      return team_b_name if score_b.to_f > score_a.to_f

      nil
    end

    def match_source_id(code, phase, group_key, round_number, team_a_name, team_b_name)
      [
        "match",
        championship_source_id,
        phase,
        group_key,
        round_number,
        code,
        team_a_name,
        team_b_name
      ].join("-").parameterize
    end

    def championship_source_id
      "11-torneio-de-tranca-ec-pinheiros-2026"
    end

    def category_source_id
      "category-#{championship_source_id}"
    end

    def tranca_setting_source_id(championship)
      "tranca-setting-#{championship.source_id}"
    end

    def entity_source_id(team_name)
      "entity-#{championship_source_id}-#{team_name.parameterize}"
    end

    def team_source_id(team_name)
      "team-#{championship_source_id}-#{team_name.parameterize}"
    end

    def header_group_key(row)
      values = row.values.compact.map { |value| value.to_s.squish }

      values.each do |value|
        match = value.match(/\ACHAVE\s+([A-I1-4])\b/i)
        return match[1].upcase if match.present?
      end

      nil
    end

    def knockout_group_key_for(code)
      case code.to_s.squish.upcase
      when /\AQF/
        "QF"
      when /\ASF/
        "SF"
      when /\AFINAL/
        "FINAL"
      when /\A3º\/4º/
        "3-4"
      else
        "MATA_MATA"
      end
    end

    def knockout_round_number_for(code)
      case code.to_s.squish.upcase
      when /\AQF/
        1
      when /\ASF/
        2
      else
        3
      end
    end

    def phase_sort_key(phase)
      phase.to_s == "classificatoria" ? 0 : 1
    end

    def group_sort_key(group_key)
      return 100 if group_key.blank?

      if group_key.match?(/\A\d+\z/)
        group_key.to_i
      else
        group_key.to_s.ord
      end
    end

    def sheet_rows
      @sheet_rows ||= begin
        workbook_sheet_map.each_with_object({}) do |(sheet_name, target), hash|
          hash[sheet_name] = extract_rows(target, sheet_name)
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

    def extract_rows(target, sheet_name)
      doc = xml_for(target)
      doc.remove_namespaces!

      doc.xpath("//sheetData/row").map do |row|
        row.xpath("c").each_with_object({ "__row_number__" => row["r"], "__sheet_name__" => sheet_name }) do |cell, hash|
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

    TEAM_ALIASES = {
      "ELIZABETA MALAGOLI E LUÍZA BIANCO CHECCIA" => "ELISABETA MALAGOLI E LUÍZA BIANCO CHECCIA"
    }.freeze
  end
end
