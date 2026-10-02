require "open3"
require "json"
require "rexml/document"
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
      extracted_score = extract_match_score(lines) || extract_period_score(sections[:score].presence || lines)
      header[:score_left] = extracted_score[:left] if extracted_score[:left].present?
      header[:score_right] = extracted_score[:right] if extracted_score[:right].present?
      header[:score_left] = match.score_a if header[:score_left].nil?
      header[:score_right] = match.score_b if header[:score_right].nil?
      header[:date] ||= match.scheduled_on&.to_s
      own_goal_lines = (sections[:own_goals] + lines).uniq
      own_goals = extract_own_goals(own_goal_lines)
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
      if (grid_events = extract_printed_grid_events)
        sides.each { |side, rows| apply_printed_grid_events!(rows, side, grid_events) }
        header[:score_left] = @printed_score[:left] if @printed_score
        header[:score_right] = @printed_score[:right] if @printed_score
      end
      fill_score_from_detected_goals!(header, sides, own_goals)

      {
        file_name: upload_file_name,
        file_content_type: upload_content_type,
        raw_text: text,
        extracted_lines: lines,
        header: header,
        sides: sides,
        own_goals: own_goals,
        warnings: warnings_for(text, header, sides, own_goals)
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

    # Digital PDFs preserve the table's coordinates. Use those positions to map
    # each printed goal minute back to its player row instead of guessing from
    # the flattened text order.
    def extract_printed_grid_events
      return if image_file?

      Tempfile.create(["match-summula-layout", ".pdf"]) do |tmp|
        File.binwrite(tmp.path, File.binread(file.path))
        stdout, stderr, status = Open3.capture3("pdftotext", "-bbox-layout", tmp.path, "-")
        return unless status.success?

        document = REXML::Document.new(stdout)
        words = REXML::XPath.match(document, "//*[local-name()='word']").map do |word|
          [word.attributes["xMin"].to_f, word.attributes["yMin"].to_f, word.text.to_s.strip]
        end
        score_line = words.select { |_x, y, _text| y > 400 }.map(&:last).join(" ")
        if (score = score_line.match(/Placar:\s*(\d{1,2})\s*[x×]\s*(\d{1,2})/i))
          @printed_score = { left: score[1].to_i, right: score[2].to_i }
        end

        layouts = {}
        { left: 27.0, right: 429.0 }.each do |side, number_x|
          header_y = words.select { |x, y, text| (x - number_x).abs < 4 && text.casecmp("Nº").zero? }.map { |_x, y, _| y }.first
          next unless header_y

          minute_columns = words.filter_map do |x, y, text|
            next unless (y - header_y).abs < 2 && text.match?(/\A[1-9][º°o]\z/i)
            next if side == :left && x >= 420
            next if side == :right && x <= 420
            x
          end.sort
          next if minute_columns.empty?

          rows = {}
          words.each do |x, y, text|
            next unless (x - number_x).abs < 5 && (y - header_y) > 4 && text.match?(/\A\d{1,2}\z/)
            shirt = text.to_i.to_s.rjust(2, "0")
            rows[shirt] = y
          end
          card_x = words.find { |x, y, text| (y - header_y).abs < 2 && normalize_text(text) == "amar" && (side == :left ? x < 420 : x > 420) }&.first
          layouts[side] = { header_y: header_y, columns: minute_columns, card_x: card_x, rows: rows, words: words }
        end
        @printed_card_markers = extract_printed_card_markers
        layouts
      end
    rescue StandardError => e
      Rails.logger.info("[match_summula_import] Could not read PDF table coordinates: #{e.class}: #{e.message}")
      nil
    end

    def apply_printed_grid_events!(rows, side, layouts)
      layout = layouts[side]
      return unless layout

      rows.each do |row|
        row_y = layout[:rows][row[:shirt_number].to_s.rjust(2, "0")]
        next unless row_y

        minutes = layout[:words].filter_map do |x, y, text|
          next unless (y - row_y).abs <= 4.5 && text.match?(/\A\d{1,3}'\z/)
          next unless layout[:columns].any? { |column_x| (x - column_x).abs < 5 }
          text.to_i
        end
        row[:goal_minutes] = minutes.uniq.join(", ") if minutes.any?
        markers = Array(@printed_card_markers).select do |marker|
          layout[:card_x] && (marker[:x] - layout[:card_x]).abs < 12 && (marker[:y] - row_y).abs <= 5
        end
        row[:cartao_amarelo] = true if markers.any? { |marker| marker[:color] == "yellow" }
        row[:cartao_vermelho] = true if markers.any? { |marker| marker[:color] == "red" }
      end
    end

    def extract_printed_card_markers
      stdout, _stderr, status = Open3.capture3(ocr_python_path, ocr_script_path.to_s, file.path.to_s, "--card-markers")
      return [] unless status.success?

      JSON.parse(stdout, symbolize_names: true)
    rescue StandardError => e
      Rails.logger.info("[match_summula_import] Could not detect colored card marks: #{e.class}: #{e.message}")
      []
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
        next unless line.match?(/\A\d{1,2}\s+/)
        next if line.match?(/\A\d{1,2}(\s+\d{1,2})+\z/)

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
      sections = { header: [], score: [], left: [], right: [], own_goals: [] }
      current = :header

      lines.each do |line|
        case line
        when /\A\[\[HEADER\]\]\z/i
          current = :header
          next
        when /\A\[\[SCORE\]\]\z/i
          current = :score
          next
        when /\A\[\[TEAM_A\]\]\z/i
          current = :left
          next
        when /\A\[\[TEAM_B\]\]\z/i
          current = :right
          next
        when /\A\[\[OWN_GOALS\]\]\z/i
          current = :own_goals
          next
        end

        sections[current] << line
      end

      sections
    end

    def extract_own_goals(lines)
      result = {
        left: { detected: false, occurred: false, minutes: [] },
        right: { detected: false, occurred: false, minutes: [] }
      }

      lines.each do |line|
        side = if line.match?(/\b(?:EQUIPE|TEAM)\s*A\b/i)
          :left
        elsif line.match?(/\b(?:EQUIPE|TEAM)\s*B\b/i)
          :right
        end
        next unless side && line.match?(/GOL\s*CONTRA/i)

        minutes_text = line.split(/MINUTOS?/i, 2).last.to_s
        minutes = minutes_text.scan(/\b\d{1,3}\b/).map(&:to_i).select { |minute| minute <= 150 }
        marked_yes = line.match?(/(?:\[\s*[xX✓]\s*\]|\bx\b)\s*SIM/i)
        marked_no = line.match?(/(?:\[\s*[xX✓]\s*\]|\bx\b)\s*N[ÃA]O/i)

        result[side] = {
          detected: true,
          occurred: marked_no ? false : (marked_yes || minutes.any?),
          minutes: minutes.first(9)
        }
      end

      result
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

    def extract_period_score(lines)
      left_total = 0
      right_total = 0

      lines.each do |line|
        tokens = line.scan(/[A-Za-z0-9'°\.]+|[xX]/)
        next if tokens.blank?

        index = 0
        while index < tokens.length
          unless period_label_token?(tokens[index])
            index += 1
            next
          end

          index += 1
          left_score = nil
          right_score = nil

          while index < tokens.length && !period_label_token?(tokens[index]) && !tokens[index].match?(/\A[xX]\z/)
            left_score ||= score_token_value(tokens[index])
            index += 1
          end

          index += 1 if index < tokens.length && tokens[index].match?(/\A[xX]\z/)

          while index < tokens.length && !period_label_token?(tokens[index]) && !tokens[index].match?(/\A[xX]\z/)
            right_score ||= score_token_value(tokens[index])
            index += 1
          end

          left_total += left_score.to_i if left_score.present?
          right_total += right_score.to_i if right_score.present?
        end
      end

      {
        left: left_total.positive? ? left_total : nil,
        right: right_total.positive? ? right_total : nil
      }
    end

    def extract_match_score(lines)
      line = lines.find { |value| normalize_text(value).include?("placar") }
      score = line&.match(/placar\s*:?\s*(\d{1,2})\s*[x×]\s*(\d{1,2})/i)
      return unless score

      { left: score[1].to_i, right: score[2].to_i }
    end

    def fill_score_from_detected_goals!(header, sides, own_goals)
      scores = %i[left right].to_h do |side|
        player_goals = sides.fetch(side, []).sum do |row|
          row[:goal_minutes].to_s.split(/[;,\s]+/).count do |minute|
            minute.strip.sub(/[’']\z/, "").match?(/\A\d{1,3}\z/)
          end
        end
        own_goal = own_goals.fetch(side, {})
        own_goal_minutes = Array(own_goal[:minutes]).size
        own_goal_count = own_goal_minutes.positive? ? own_goal_minutes : (own_goal[:occurred] ? 1 : 0)

        [side, player_goals + own_goal_count]
      end
      return unless scores.values.sum.positive?

      header[:score_left] = scores[:left] if header[:score_left].nil?
      header[:score_right] = scores[:right] if header[:score_right].nil?
    end

    def score_token_value(token)
      normalized = token.to_s.strip.upcase
      return 1 if %w[TO T0 IO 1O O1 01].include?(normalized)
      return 0 if normalized == "00"
      return normalized.to_i if normalized.match?(/\A\d{1,2}\z/)
    end

    def period_label_token?(token)
      normalize_text(token).match?(/\A[123][a-z]*per\z/)
    end

    def warnings_for(text, header, sides, own_goals)
      warnings = []
      warnings << "Foto enviada: confira manualmente os times e atletas." if image_file?
      warnings << "Não consegui extrair texto legível do arquivo." if text.blank? && !image_file?
      warnings << "Não encontrei o cabeçalho do jogo no arquivo." if !image_file? && (header[:left_team_name].blank? || header[:right_team_name].blank?)
      warnings << "Não encontrei jogadores nas equipes do PDF." if sides[:left].blank? && sides[:right].blank?
      warnings << "Não consegui ler os campos de gol contra; confira as duas equipes antes de confirmar." if own_goals.values.none? { |side| side[:detected] }
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
