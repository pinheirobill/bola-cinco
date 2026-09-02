require "open3"
require "tempfile"

begin
  require "pdf/reader"
rescue LoadError
end

module BolaCinco
  class MatchSummulaImport
    def initialize(match:, file:)
      @match = match
      @file = file
    end

    def call
      text = extract_text
      lines = text.lines.map { |line| line.strip.gsub(/\s+/, " ") }.reject(&:blank?)
      sections = split_ocr_sections(lines)
      header_lines = sections[:header].presence || lines
      header = extract_header(header_lines)
      header[:left_team_name] ||= match.team_a&.name
      header[:right_team_name] ||= match.team_b&.name
      header[:score_left] ||= match.score_a
      header[:score_right] ||= match.score_b
      header[:date] ||= match.scheduled_on&.to_s
      sides = if sections[:left].any? || sections[:right].any?
        {
          left: extract_roster_rows_from_section(sections[:left], :left),
          right: extract_roster_rows_from_section(sections[:right], :right)
        }.tap do |result|
          fallback = fallback_roster_rows
          result[:left] = fallback[:left] if result[:left].blank? && fallback[:left].present?
          result[:right] = fallback[:right] if result[:right].blank? && fallback[:right].present?
        end
      elsif lines.any?
        parsed_sides = extract_roster_rows(lines)
        parsed_sides[:left].blank? && parsed_sides[:right].blank? ? fallback_roster_rows : parsed_sides
      else
        fallback_roster_rows
      end

      {
        file_name: upload_file_name,
        file_content_type: upload_content_type,
        raw_text: text,
        extracted_lines: lines,
        header: header,
        sides: sides,
        warnings: warnings_for(text, header, sides)
      }
    end

    private

    attr_reader :match, :file

    def upload_file_name
      file.respond_to?(:original_filename) ? file.original_filename : File.basename(file.path.to_s)
    end

    def upload_content_type
      file.respond_to?(:content_type) ? file.content_type : nil
    end

    def image_file?
      upload_content_type.to_s.start_with?("image/")
    end

    def extract_text
      extracted = extract_with_pdf_reader
      return extracted if extracted.present?

      extracted = extract_with_pdftotext
      return extracted if extracted.present?

      extract_with_ocr
    end

    def extract_with_pdf_reader
      return unless defined?(PDF::Reader)

      PDF::Reader.new(file.path).pages.map(&:text).join("\n")
    rescue StandardError
      ""
    end

    def extract_with_pdftotext
      return "" if image_file?

      Tempfile.create(["match-summula-import", ".pdf"]) do |tmp|
        File.binwrite(tmp.path, File.binread(file.path))

        txt_path = "#{tmp.path}.txt"
        stdout, stderr, status = Open3.capture3("pdftotext", "-layout", tmp.path, txt_path)
        raise stderr.presence || stdout.presence || "pdftotext failed" unless status.success?

        File.read(txt_path)
      ensure
        File.delete(txt_path) if defined?(txt_path) && File.exist?(txt_path)
      end
    rescue StandardError
      ""
    end

    def extract_with_ocr
      return "" unless ocr_available?

      stdout, stderr, status = Open3.capture3(ocr_python_path, ocr_script_path.to_s, file.path.to_s)
      return stdout.to_s if status.success?

      Rails.logger.warn("[match_summula_import] OCR failed: #{stderr.presence || stdout.presence || status.exitstatus}")
      ""
    rescue StandardError => e
      Rails.logger.warn("[match_summula_import] OCR error: #{e.class}: #{e.message}")
      ""
    end

    def ocr_available?
      File.exist?(ocr_script_path) && (ocr_python_path == "python3" || File.exist?(ocr_python_path))
    end

    def ocr_python_path
      @ocr_python_path ||= begin
        configured = ENV["OCR_PYTHON"].presence
        if configured.present? && File.exist?(configured)
          configured
        else
          local_venv = Rails.root.join(".ocr-venv/bin/python")
          if File.exist?(local_venv)
            local_venv.to_s
          else
            "python3"
          end
        end
      end
    end

    def ocr_script_path
      Rails.root.join("script/ocr_summula.py")
    end

    def extract_header(lines)
      header_line = lines.find { |line| line.match?(/\b\d{1,2}\s*x\s*\d{1,2}\b/i) }
      match_data = header_line&.match(/\A(?<left>.+?)\s+(?<score_left>\d{1,2})\s*x\s*(?<score_right>\d{1,2})\s+(?<right>.+)\z/i)

      {
        left_team_name: match_data&.[](:left)&.strip,
        score_left: match_data&.[](:score_left)&.to_i,
        score_right: match_data&.[](:score_right)&.to_i,
        right_team_name: match_data&.[](:right)&.strip,
        competition: find_value_after_label(lines, "competi"),
        category: find_value_after_label(lines, "categoria"),
        venue: find_value_after_label(lines, "ginasio") || find_value_after_label(lines, "campo"),
        date: find_date(lines)
      }
    end

    def extract_roster_rows(lines)
      sections = { left: [], right: [] }
      current_side = nil

      lines.each_with_index do |line, index|
        case line
        when /\A\[\[TEAM_A\]\]\z/i
          current_side = :left
          next
        when /\A\[\[TEAM_B\]\]\z/i
          current_side = :right
          next
        when /\Aequipe\s*a\b/i
          current_side = :left
          next
        when /\Aequipe\s*b\b/i
          current_side = :right
          next
        when /\Atecnico\b/i, /\Aarbitro\b/i, /\Aplacar\b/i
          current_side = nil
          next
        end

        next if current_side.blank?
        next unless line.match?(/\A\d{1,2}\s+/)
        next if line.match?(/\A\d{1,2}(\s+\d{1,2})+\z/)

        if (row = parse_player_row(line, index, current_side))
          sections[current_side] << row
        end
      end

      {
        left: sections[:left],
        right: sections[:right]
      }
    end

    def extract_roster_rows_from_section(lines, side)
      lines.each_with_index.filter_map do |line, index|
        parse_player_row(line, index, side)
      end
    end

    def parse_player_row(line, index, side)
      return if line.blank? || roster_label_line?(line)

      shirt_number = extract_shirt_number(line)
      name = extract_player_name(line)
      return if name.blank?

      {
        index: index,
        side: side,
        shirt_number: shirt_number&.to_s&.rjust(2, "0"),
        player_name: name,
        source_line: line,
        suggested_athlete: suggested_athlete_for(side, shirt_number, name)
      }
    end

    def extract_shirt_number(line)
      line[/\b\d{1,2}\b/]
    end

    def extract_player_name(line)
      cleaned = line.dup
      cleaned.gsub!(/\[\[(?:TEAM_A|TEAM_B|HEADER)\]\]/i, " ")
      cleaned.gsub!(/\b(?:equipe\s*a|equipe\s*b|team\s*a|team\s*b|header|jogadores|registro|substituicoes|iniciantes|amar|verm|tecnico|capitao|placar|acumulativas|horario|inicio|term|data|competicao|categoria|divisao|serie|ginasio|cidade|anotador|arbitro1|arbitro2|bola\s+cinco|esportes|sub|subu|per|1per|2per|3per|1°per|2°per|3°per)\b/i, " ")
      cleaned.gsub!(/\b\d{1,4}(?:[x:\/.\-]\d{1,4})*\b/, " ")
      cleaned.gsub!(/[^\p{L}\s]+/u, " ")
      cleaned.squish
      cleaned.presence
    end

    def roster_label_line?(line)
      normalized = normalize_text(line)
      return true if normalized.blank?

      normalized.match?(/\A(?:equipe a|equipe b|team a|team b|header|jogadores|registro|substituicoes|iniciantes|amar|verm|tecnico|capitao|placar|acumulativas|horario|inicio|term|data|competicao|categoria|divisao|serie|ginasio|cidade|anotador|arbitro1|arbitro2|bola cinco|esportes|1per|2per|3per)\z/)
    end

    def split_ocr_sections(lines)
      sections = { header: [], left: [], right: [] }
      current = :header

      lines.each do |line|
        case line
        when /\A\[\[HEADER\]\]\z/i
          current = :header
          next
        when /\A\[\[TEAM_A\]\]\z/i
          current = :left
          next
        when /\A\[\[TEAM_B\]\]\z/i
          current = :right
          next
        end

        sections[current] << line
      end

      sections
    end

    def suggested_athlete_for(side, shirt_number, player_name)
      team = side == :left ? match.team_a : match.team_b
      pool = Array(team&.athletes&.includes(:team).to_a)
      pool = Array(match.team_a&.athletes&.includes(:team).to_a) + Array(match.team_b&.athletes&.includes(:team).to_a) if pool.blank?
      pool = pool.uniq(&:id)

      best = pool.max_by { |athlete| athlete_score(athlete, shirt_number, player_name) }
      return if best.blank?

      {
        id: best.id,
        name: best.match_roster_label,
        team_name: best.team&.name,
        confidence: athlete_score(best, shirt_number, player_name)
      }
    end

    def athlete_score(athlete, shirt_number, player_name)
      score = 0.0
      score += 2.0 if athlete.shirt_number.to_s.strip == shirt_number.to_s.strip
      score += 1.5 if normalize_text(athlete.name) == normalize_text(player_name)
      score += name_overlap_score(athlete.name, player_name)
      score
    end

    def name_overlap_score(left, right)
      left_words = normalize_text(left).split
      right_words = normalize_text(right).split
      return 0.0 if left_words.blank? || right_words.blank?

      (left_words & right_words).size.to_f / [left_words.size, right_words.size].max
    end

    def normalize_text(value)
      I18n.transliterate(value.to_s).downcase.gsub(/[^a-z0-9]+/, " ").squish
    end

    def find_value_after_label(lines, label)
      index = lines.find_index { |line| normalize_text(line).include?(normalize_text(label)) }
      return if index.blank?

      value = lines[index].sub(/.*#{Regexp.escape(label)}.*?:?\s*/i, "").strip
      value.presence || lines[index + 1]
    end

    def find_date(lines)
      lines.find { |line| line.match?(/\b\d{2}[\/\-]\d{2}[\/\-]\d{4}\b/) }
    end

    def warnings_for(text, header, sides)
      warnings = []
      warnings << "Foto enviada: confira manualmente os times e atletas." if image_file?
      warnings << "Não consegui extrair texto legível do arquivo." if text.blank? && !image_file?
      warnings << "Não encontrei o cabeçalho do jogo no arquivo." if !image_file? && (header[:left_team_name].blank? || header[:right_team_name].blank?)
      warnings << "Não encontrei jogadores nas equipes do PDF." if sides[:left].blank? && sides[:right].blank?
      warnings
    end

    def fallback_roster_rows
      {
        left: roster_rows_for(match.team_a, :left),
        right: roster_rows_for(match.team_b, :right)
      }
    end

    def roster_rows_for(team, side)
      return [] if team.blank?

      team.athletes.order(:shirt_number, :name).map.with_index do |athlete, index|
        {
          index: index,
          side: side,
          shirt_number: athlete.shirt_number.to_s.rjust(2, "0"),
          player_name: athlete.name,
          source_line: athlete.match_roster_label,
          suggested_athlete: {
            id: athlete.id,
            name: athlete.match_roster_label,
            team_name: team.name,
            confidence: 2.5
          }
        }
      end
    end
  end
end
