require "json"
require "date"
require "tempfile"
require "zip"
require "nokogiri"

module BolaCinco
  class ChisCupWorkbookImporter
    TEAM_ALIASES = {
      "CDD EMBÚ" => "CDD EMBU DAS ARTES",
      "CDD EMBÚ DAS ARTES" => "CDD EMBU DAS ARTES",
      "CDD EMBU" => "CDD EMBU DAS ARTES",
      "UNIÃO CARRÃO" => "UNIÃO VILA CARRÃO",
      "UNIÃO VILA CARRÃO" => "UNIÃO VILA CARRÃO",
      "DIFERENTES" => "DIFERENTE F.C.",
      "DIFERENTE" => "DIFERENTE F.C.",
      "DIFERENTE F.C." => "DIFERENTE F.C.",
      "AJAX" => "AJAX CENTRO",
      "AJAX CENTRO" => "AJAX CENTRO",
      "U.F.C." => "UFC - UNIÃO FC",
      "UFC" => "UFC - UNIÃO FC",
      "UFC - UNIÃO FC" => "UFC - UNIÃO FC",
      "V. N. CACHOEIRINHA" => "VILA NOVA CACHOEIRINHA",
      "SEM FÉRIAS" => "SEM FÉRIAS/100 PERRECO",
      "SEM FÉRIAS/100 PERRECO" => "SEM FÉRIAS/100 PERRECO",
      "SEM FÉRIAS/ 100 PERRECO" => "SEM FÉRIAS/100 PERRECO",
      "SÓ MITO FS" => "SÓ MITO FC",
      "SÓ MITO FUT SAMBA" => "SÓ MITO FC",
      "SÓ MITO FC" => "SÓ MITO FC",
      "GUERREIROS DO ITAIM" => "GUERREIROS DO ITAIM",
      "GERREIROS ITAIM" => "GUERREIROS DO ITAIM",
      "UNIDOS TECA" => "UNIDOS TECA JAGUARÉ",
      "UNIDOS TECA JAGUARÉ" => "UNIDOS TECA JAGUARÉ",
      "UNIÃO Z.NORTE" => "UNIÃO ZONA NORTE",
      "UNIÃO ZONA NORTE" => "UNIÃO ZONA NORTE",
      "PC FC PIRITUBA" => "PC FC - CDD PIRITUBA",
      "PC FC - CDD PIRITUBA" => "PC FC - CDD PIRITUBA",
      "MIXTO FC" => "MIXTO",
      "MIXTO" => "MIXTO",
      "ASSUNÇÃO W.O." => "ASSUNÇÃO",
      "ASSUNÇÃO - W.O." => "ASSUNÇÃO",
      "ASSUNÇÃO" => "ASSUNÇÃO",
      "RESOLVE FÁCIL" => "RESOLVE FÁCIL"
    }.freeze

    GROUP_STAGE_GROUPS = %w[A B C D].freeze
    GROUP_STAGE_START_ROW = 68
    GROUP_STAGE_END_ROW = 160
    SUPPLEMENTAL_START_ROW = 1
    SUPPLEMENTAL_END_ROW = 14

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

      Tempfile.create(["chis-cup-workbook-import", ".json"]) do |file|
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
      parsed_matches = {}
      parsed_venues = {}
      parsed_team_groups = {}

      parse_section(
        sheet_name: "PROGRAMAÇÃO",
        row_range: GROUP_STAGE_START_ROW..GROUP_STAGE_END_ROW
      ) do |candidate|
        next if candidate.blank?

        merge_candidate!(parsed_matches, candidate)
        register_team_group!(parsed_team_groups, candidate)
        register_venue!(parsed_venues, candidate)
      end

      parse_section(
        sheet_name: "Rodadas",
        row_range: SUPPLEMENTAL_START_ROW..SUPPLEMENTAL_END_ROW
      ) do |candidate|
        next if candidate.blank?

        merge_candidate!(parsed_matches, candidate)
        register_team_group!(parsed_team_groups, candidate)
        register_venue!(parsed_venues, candidate)
      end

      team_rows = parsed_team_groups.values.sort_by { |item| [item.fetch(:group_key), item.fetch(:name)] }
      teams = team_rows.map do |item|
        team_source_id = team_source_id(item.fetch(:group_key), item.fetch(:name))
        entity_id = entity_source_id(item.fetch(:name))

        {
          "id" => team_source_id,
          "entityId" => entity_id,
          "categoryId" => category_source_id,
          "group" => item.fetch(:group_key),
          "name" => item.fetch(:name),
          "shortName" => item.fetch(:name),
          "registration" => {
            "status" => "aprovada"
          },
          "finance" => {
            "status" => "pendente"
          }
        }
      end

      entities = team_rows.map do |item|
        {
          "id" => entity_source_id(item.fetch(:name)),
          "name" => item.fetch(:name)
        }
      end

      matches = parsed_matches.values.sort_by do |item|
        [
          phase_sort_key(item.fetch(:phase)),
          item.fetch(:round_number).to_i,
          item[:scheduled_on].presence || "9999-12-31",
          item[:scheduled_time].presence || "99:99",
          item.fetch(:sort_key)
        ]
      end.map do |item|
        match_payload_for(item)
      end

      {
        championship: championship_payload,
        categories: [category_payload],
        entities: entities.uniq { |item| item.fetch("id") },
        teams: teams.uniq { |item| item.fetch("id") },
        venues: parsed_venues.values.sort_by { |item| item.fetch("name") },
        matches: matches,
        rules: rules_payload,
        format: format_payload(teams.size),
        scoring: scoring_payload,
        notes: notes_payload
      }
    end

    def parse_section(sheet_name:, row_range:)
      rows = sheet_rows.fetch(sheet_name)
      current_context = {
        sheet: sheet_name,
        round_number: nil,
        phase: "classificatoria",
        venue_name: nil,
        venue_address: nil,
        date: nil
      }

      rows.each do |row|
        row_number = row.fetch("__row_number__").to_i
        next unless row_range.cover?(row_number)

        header_text = [row["A"], row["B"], row["C"], row["D"], row["E"], row["F"], row["G"], row["H"]].compact.join(" ").squish
        if header_text.match?(/RODADA|QUARTAS|SEMIFINAIS|ENCERRAMENTO|FINAL/i)
          update_context!(current_context, header_text, row)
          next
        end

        candidate = parse_match_row(row, current_context)
        yield candidate if candidate.present?

        if row["A"].to_s.match?(/\ALOCAL\b/i)
          current_context[:venue_name] = canonical_venue_name(parse_local_venue_name(row["A"]))
          current_context[:venue_address] = parse_local_address(row["A"])
        end

        if row["A"].to_s.match?(/\AENDERE[CÇ]O:/i)
          current_context[:venue_address] = row["A"].to_s.sub(/\AENDERE[CÇ]O:\s*/i, "").squish.presence
        end
      end
    end

    def update_context!(current_context, header_text, row)
      current_context[:phase] = header_text.match?(/QUARTAS|SEMIFINAIS|ENCERRAMENTO|FINAL/i) ? "mata_mata" : "classificatoria"
      current_context[:round_number] = extract_round_number(header_text) || current_context[:round_number]
      current_context[:date] = parse_header_date(header_text) || current_context[:date]

      venue_name, venue_address = parse_header_venue(header_text)
      if venue_name.present?
        current_context[:venue_name] = venue_name
        current_context[:venue_address] = venue_address if venue_address.present?
      end

      if row["A"].to_s.match?(/\ALOCAL\b/i)
        current_context[:venue_name] = canonical_venue_name(parse_local_venue_name(row["A"]))
        current_context[:venue_address] = parse_local_address(row["A"])
      end
    end

    def parse_match_row(row, current_context)
      group_key_raw = row["B"].to_s.squish
      return nil if group_key_raw.blank?

      phase = phase_for(current_context, group_key_raw, row)
      return nil unless allowed_group_key?(group_key_raw, phase)
      group_key = group_key_for(current_context, group_key_raw, phase)
      round_number = round_number_for(current_context, phase)
      time = normalized_time(row["A"])
      team_a_label = row["C"].to_s.squish
      team_b_label = row["G"].to_s.squish
      note = row["H"].to_s.squish.presence

      team_a_label = apply_row_corrections!(team_a_label, team_b_label, note, row)
      team_b_label = apply_row_b_corrections!(team_b_label, note, row)

      score_a = parse_score(row["D"])
      score_b = parse_score(row["F"])
      status = parse_status(row, score_a, score_b)

      source_a_label = source_label_for(team_a_label)
      source_b_label = source_label_for(team_b_label)
      canonical_a = canonical_team_name(team_a_label)
      canonical_b = canonical_team_name(team_b_label)
      has_actual_teams = actual_team_name?(source_a_label) && actual_team_name?(source_b_label)

      sort_key = if has_actual_teams
        canonical_pair_key(canonical_a, canonical_b)
      else
        [source_a_label, source_b_label].join(" x ")
      end

      candidate = {
        phase: phase,
        group_key: group_key,
        round_number: round_number,
        scheduled_on: current_context[:date]&.iso8601,
        scheduled_time: time,
        venue_name: current_context[:venue_name],
        venue_address: current_context[:venue_address],
        code: code_for(current_context, row, group_key, source_a_label, source_b_label),
        source_a: { "name" => source_a_label },
        source_b: { "name" => source_b_label },
        score_a: score_a,
        score_b: score_b,
        status: status,
        note: note,
        sort_key: sort_key,
        row_number: row.fetch("__row_number__").to_i,
        sheet_name: current_context[:sheet],
        raw_a: row["A"].to_s.squish,
        raw_b: row["B"].to_s.squish
      }

      if has_actual_teams
        candidate[:team_a_name] = canonical_a
        candidate[:team_b_name] = canonical_b
        candidate[:winner_name] = winner_name_for(canonical_a, canonical_b, score_a, score_b, status)
      end

      if knockout_placeholder?(team_a_label, team_b_label, row)
        candidate[:team_a_name] = nil
        candidate[:team_b_name] = nil
      end

      candidate
    end

    def allowed_group_key?(group_key_raw, phase)
      normalized = group_key_raw.to_s.squish.upcase
      return true if normalized.match?(/\A[ABCD]\z/)
      return true if normalized.match?(/\ACHAVE\s*[EF]\z/)
      return true if normalized.match?(/\ASF\d+\z/)
      return true if phase == "mata_mata" && normalized.match?(/\A(?:PERD|VENC|TITULO|FINAL)\b/)

      false
    end

    def merge_candidate!(matches_by_key, candidate)
      key = match_key(candidate)
      existing = matches_by_key[key]
      matches_by_key[key] = if existing.present?
        merge_match_candidates(existing, candidate)
      else
        candidate
      end
    end

    def merge_match_candidates(existing, incoming)
      merged = existing.deep_dup
      incoming_confirmed = incoming[:score_a].present? || incoming[:score_b].present? || incoming[:status] == "wo" || incoming[:status] == "finalizado"
      existing_confirmed = merged[:score_a].present? || merged[:score_b].present? || merged[:status] == "wo" || merged[:status] == "finalizado"

      %i[scheduled_on scheduled_time venue_name venue_address code phase group_key round_number].each do |field|
        next if incoming[field].blank?
        next if existing_confirmed && !incoming_confirmed

        merged[field] = incoming[field]
      end

      if incoming[:status].present?
        next_status = incoming[:status]
        next_status = merged[:status] if merged[:status].present? && merged[:status] != "agendado" && next_status == "agendado"
        merged[:status] = next_status
      end

      %i[score_a score_b].each do |field|
        merged[field] = incoming[field] if incoming[field].present?
      end

      merged[:source_a] = incoming[:source_a] if incoming[:source_a].present?
      merged[:source_b] = incoming[:source_b] if incoming[:source_b].present?

      if incoming[:team_a_name].present? && incoming[:team_b_name].present?
        merged[:team_a_name] = incoming[:team_a_name]
        merged[:team_b_name] = incoming[:team_b_name]
        merged[:winner_name] = incoming[:winner_name]
      end

      merged[:sort_key] = incoming[:sort_key] if incoming[:sort_key].present?
      merged[:note] = [existing[:note], incoming[:note]].compact_blank.last
      merged
    end

    def register_team_group!(team_groups, candidate)
      return unless candidate[:phase] == "classificatoria"
      return if candidate[:team_a_name].blank? || candidate[:team_b_name].blank?

      [[candidate[:team_a_name], candidate[:group_key]], [candidate[:team_b_name], candidate[:group_key]]].each do |name, group_key|
        next if name.blank? || group_key.blank?

        team_groups[name] ||= {
          name: name,
          group_key: group_key
        }
      end
    end

    def register_venue!(venues, candidate)
      venue_name = candidate[:venue_name].to_s.squish
      return if venue_name.blank?

      venues[venue_name] ||= {
        "id" => venue_source_id(venue_name),
        "name" => venue_name,
        "shortName" => venue_name,
        "address" => candidate[:venue_address],
        "city" => infer_city(candidate[:venue_address]),
        "notes" => candidate[:venue_address],
        "status" => "ativo"
      }
    end

    def match_payload_for(item)
      payload = {
        "id" => match_source_id(item),
        "categoryId" => category_source_id,
        "code" => item.fetch(:code),
        "phase" => item.fetch(:phase),
        "group" => item[:group_key],
        "round" => item[:round_number],
        "date" => item[:scheduled_on],
        "time" => item[:scheduled_time],
        "teamAId" => item[:team_a_name].present? ? team_source_id(item[:group_key], item[:team_a_name]) : nil,
        "teamBId" => item[:team_b_name].present? ? team_source_id(item[:group_key], item[:team_b_name]) : nil,
        "sourceA" => item.fetch(:source_a),
        "sourceB" => item.fetch(:source_b),
        "scoreA" => item[:score_a],
        "scoreB" => item[:score_b],
        "status" => item.fetch(:status),
        "venue" => item[:venue_name],
        "_source" => {
          "sheet" => item[:sheet_name],
          "row" => item[:row_number],
          "note" => item[:note],
          "rawA" => item[:raw_a],
          "rawB" => item[:raw_b]
        }
      }

      payload["winnerId"] = item[:winner_name].present? ? team_source_id(item[:group_key], item[:winner_name]) : nil
      payload
    end

    def championship_payload
      {
        "id" => "chis-cup-2026",
        "name" => "CHIS CUP 2026",
        "season" => 2026,
        "status" => "em_andamento"
      }
    end

    def category_payload
      {
        "id" => category_source_id,
        "name" => "CHIS CUP 2026",
        "gender" => "masculino",
        "maxAthletes" => 25
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

    def format_payload(team_count)
      {
        "mode" => "grupos_mata_mata",
        "teamCount" => team_count,
        "groupCount" => 4,
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
        Jogos importados das abas PROGRAMAÇÃO e Rodadas do CHIS CUP 2026.
        As linhas de revisão e os duplicados entre as abas foram consolidados por confronto e fase.
        A competição foi configurada como fase de grupos seguida de mata-mata, com 2 classificados por grupo.
      TEXT
    end

    def phase_for(current_context, group_key_raw, row)
      return "mata_mata" if current_context[:phase] == "mata_mata"
      return "mata_mata" if group_key_raw.match?(/\A(?:CHAVE\s*[EF]|SF\d+|PERD|VENC|TITULO|FINAL)\z/i)
      return "mata_mata" if row["A"].to_s.match?(/\A(?:SF\d+|PERD|VENC|TITULO|FINAL)\b/i)

      "classificatoria"
    end

    def phase_sort_key(phase)
      case phase.to_s
      when "classificatoria"
        0
      when "mata_mata"
        1
      else
        2
      end
    end

    def group_key_for(current_context, group_key_raw, phase)
      normalized = group_key_raw.to_s.squish.upcase
      return normalized.gsub(/\s+/, "") if normalized.match?(/\ASF\d+\z/)

      if normalized.match?(/\ACHAVE\s*([EF])\z/)
        return Regexp.last_match(1)
      end

      return "SF" if phase == "mata_mata" && normalized.match?(/\A(?:SF\d+|PERD|VENC|TITULO|FINAL)\b/)

      normalized if GROUP_STAGE_GROUPS.include?(normalized)
    end

    def round_number_for(current_context, phase)
      current_context[:round_number].presence || (phase == "mata_mata" ? 1 : 1)
    end

    def parse_status(row, score_a, score_b)
      return "wo" if row["A"].to_s.match?(/\A(?:EXCLU[IÍ]DO|W\.?O\.?)\b/i)
      return "finalizado" if score_a.present? && score_b.present?

      "agendado"
    end

    def winner_name_for(team_a_name, team_b_name, score_a, score_b, status)
      return team_b_name if status == "wo" && score_a.to_f < score_b.to_f
      return team_a_name if status == "wo" && score_a.to_f > score_b.to_f
      return nil unless score_a.present? && score_b.present?

      if score_a.to_f > score_b.to_f
        team_a_name
      elsif score_b.to_f > score_a.to_f
        team_b_name
      end
    end

    def knockout_placeholder?(team_a_label, team_b_label, row)
      placeholder_label?(team_a_label) || placeholder_label?(team_b_label) || row["B"].to_s.match?(/\ASF\d+\z/i)
    end

    def placeholder_label?(label)
      normalized = label.to_s.squish.upcase
      normalized.match?(/\A(?:\d+º|\d+O|\d+O\s|1º|2º|3º|PERD|VENC|SF\d+|TÍTULO|TITULO|3º LUGAR)\b/)
    end

    def apply_row_corrections!(team_a_label, team_b_label, note, row)
      corrected = team_a_label.to_s.squish
      if row["H"].to_s.match?(/TROCAR ADVERSÁRIO/i) && row["H"].to_s.match?(/RESOLVE FÁCIL/i)
        corrected = "ASSUNÇÃO"
      end

      corrected
    end

    def apply_row_b_corrections!(team_b_label, note, row)
      corrected = team_b_label.to_s.squish
      if row["H"].to_s.match?(/TROCAR ADVERSÁRIO/i) && row["H"].to_s.match?(/RESOLVE FÁCIL/i)
        corrected = "RESOLVE FÁCIL"
      end

      corrected
    end

    def canonical_team_name(name)
      normalized = name.to_s.squish.upcase
      TEAM_ALIASES.fetch(normalized, normalized)
    end

    def source_label_for(name)
      name.to_s.squish
    end

    def actual_team_name?(label)
      normalized = label.to_s.squish.upcase
      return false if normalized.blank?
      return false if placeholder_label?(normalized)
      return false if normalized.match?(/\A(?:CHAVE\s*[EF]|SF\d+)\z/)

      true
    end

    def canonical_pair_key(team_a_name, team_b_name)
      [team_a_name, team_b_name].sort.join("::")
    end

    def match_key(candidate)
      if candidate[:phase] == "classificatoria"
        [
          candidate[:phase],
          candidate[:group_key],
          canonical_pair_key(candidate[:team_a_name], candidate[:team_b_name])
        ].join("::")
      else
        pair = if candidate[:team_a_name].present? && candidate[:team_b_name].present?
          canonical_pair_key(candidate[:team_a_name], candidate[:team_b_name])
        else
          [candidate[:source_a]["name"], candidate[:source_b]["name"]].join("::")
        end

        [
          candidate[:phase],
          candidate[:group_key].presence || "general",
          candidate[:round_number].to_i,
          pair
        ].join("::")
      end
    end

    def match_source_id(item)
      [
        "match",
        "chis-cup-2026",
        item.fetch(:phase),
        item.fetch(:group_key).presence || "general",
        item.fetch(:round_number).to_i,
        item.fetch(:sort_key)
      ].join("-").parameterize
    end

    def code_for(current_context, row, group_key, source_a_label, source_b_label)
      base = row["B"].to_s.squish.presence || "#{group_key}-#{current_context[:round_number]}"
      [
        base,
        source_a_label,
        source_b_label
      ].compact.join("-").parameterize.upcase
    end

    def category_source_id
      "chis-cup-2026"
    end

    def entity_source_id(name)
      "entity-#{name.parameterize}"
    end

    def team_source_id(group_key, name)
      "team-#{category_source_id}-#{group_key}-#{name.parameterize}"
    end

    def venue_source_id(name)
      "venue-#{name.parameterize}"
    end

    def normalized_time(value)
      text = value.to_s.squish
      return nil if text.blank?
      return text.upcase if text.match?(/\A\d{1,2}H(?:\d{2})?\z/i)
      return text.upcase if text.match?(/\A\d{1,2}:\d{2}\z/)

      nil
    end

    def parse_score(value)
      text = value.to_s.squish
      return nil if text.blank?
      return nil unless text.match?(/\A\d+(?:\.\d+)?\z/)

      numeric = text.to_f
      numeric == numeric.to_i ? numeric.to_i : numeric
    end

    def parse_header_date(header)
      match = header.match(/(\d{1,2}\s*\/\s*\d{1,2}\s*\/\s*\d{2,4})/)
      return nil if match.blank?

      text = match[1].gsub(/\s+/, "")
      Date.strptime(text, text.length == 8 ? "%d/%m/%y" : "%d/%m/%Y")
    end

    def parse_header_venue(header)
      match = header.match(/\d{1,2}\s*\/\s*\d{1,2}\s*\/\s*\d{2,4}\s*-\s*(.+)\z/)
      return [nil, nil] if match.blank?

      text = match[1].squish
      venue_name = text.split(/\s+-\s+/).first.to_s.squish
      [canonical_venue_name(venue_name), nil]
    end

    def parse_local_venue_name(text)
      text.to_s.sub(/\ALOCAL\s+\d+:\s*/i, "").split(/\s+-\s+/).first.to_s.squish
    end

    def parse_local_address(text)
      text.to_s.sub(/\ALOCAL\s+\d+:\s*[^-]+-\s*/i, "").squish.presence
    end

    def extract_round_number(header)
      match = header.match(/(\d+)\s*[ªa]?\s*RODADA/i)
      return nil if match.blank?

      match[1].to_i
    end

    def canonical_venue_name(name)
      name.to_s.squish
    end

    def infer_city(address)
      return nil if address.blank?

      tail = address.split("-").last.to_s.squish
      tail.presence
    end

    def sheet_rows
      @sheet_rows ||= begin
        workbook_sheet_map.each_with_object({}) do |(sheet_name, target), hash|
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
