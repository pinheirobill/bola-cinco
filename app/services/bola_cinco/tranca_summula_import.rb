require "open3"
require "tempfile"

begin
  require "pdf/reader"
rescue LoadError
end

module BolaCinco
  class TrancaSummulaImport
    def initialize(partida:, file:)
      @partida = partida
      @file = file
    end

    def call
      text = extract_text
      lines = normalize_lines(text)

      {
        file_name: upload_file_name,
        file_content_type: upload_content_type,
        raw_text: text,
        extracted_lines: lines,
        header: extract_header(lines),
        hands: extract_hands(lines),
        warnings: warnings_for(lines)
      }
    end

    private

    attr_reader :partida, :file

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

      Tempfile.create(["tranca-summula-import", ".pdf"]) do |tmp|
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

      Rails.logger.warn("[tranca_summula_import] OCR failed: #{stderr.presence || stdout.presence || status.exitstatus}")
      ""
    rescue StandardError => e
      Rails.logger.warn("[tranca_summula_import] OCR error: #{e.class}: #{e.message}")
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
          File.exist?(local_venv) ? local_venv.to_s : "python3"
        end
      end
    end

    def ocr_script_path
      Rails.root.join("script/ocr_summula.py")
    end

    def normalize_lines(text)
      text.to_s.lines.map { |line| line.strip.gsub(/\s+/, " ") }.reject(&:blank?)
    end

    def extract_header(lines)
      {
        code: find_value_after_label(lines, "jogo"),
        mesa: find_value_after_label(lines, "mesa"),
        date: find_value_after_label(lines, "data"),
        team_a_name: partida.dupla_a_nome,
        team_b_name: partida.dupla_b_nome,
        winner_name: find_value_after_label(lines, "dupla vencedora"),
        score_a: extract_total_score(lines, :left),
        score_b: extract_total_score(lines, :right),
        round_label: find_value_after_label(lines, "rodada")
      }
    end

    def extract_hands(lines)
      labels = ["1ª batida", "2ª batida", "3ª batida", "4ª batida"]
      labels.each_with_index.map do |label, index|
        {
          numero: index + 1,
          pontos_a: extract_hand_value(lines, label, :left),
          pontos_b: extract_hand_value(lines, label, :right),
          canastra_limpa_a: false,
          canastra_limpa_b: false,
          canastra_suja_a: false,
          canastra_suja_b: false,
          batida_a: false,
          batida_b: false,
          tres_vermelho_a: false,
          tres_vermelho_b: false,
          desconto_a: 0,
          desconto_b: 0,
          observacoes: nil
        }
      end
    end

    def warnings_for(lines)
      warnings = []
      warnings << "Não foi possível confirmar o texto da súmula." if lines.blank?
      warnings << "O OCR não achou o placar automaticamente." if extract_total_score(lines, :left).blank? || extract_total_score(lines, :right).blank?
      warnings
    end

    def extract_total_score(lines, side)
      text = lines.find { |line| line.match?(/total de pontos/i) } || lines.find { |line| line.match?(/\bTOTAL\b/i) }
      return nil if text.blank?

      numbers = text.scan(/\b\d+\b/)
      return nil if numbers.size < 2

      side == :left ? numbers.first.to_i : numbers.last.to_i
    end

    def extract_hand_value(lines, label, side)
      index = lines.find_index { |line| normalize_text(line).include?(normalize_text(label)) }
      return nil if index.blank?

      nearby = lines[(index + 1)..(index + 3)] || []
      numbers = nearby.join(" ").scan(/\b\d+\b/)
      return nil if numbers.blank?

      side == :left ? numbers.first.to_i : numbers.last.to_i
    end

    def find_value_after_label(lines, label)
      index = lines.find_index { |line| normalize_text(line).include?(normalize_text(label)) }
      return nil if index.blank?

      line = lines[index]
      value = line.sub(/.*#{Regexp.escape(label)}.*?:?\s*/i, "").strip
      value.presence || lines[index + 1]
    end

    def normalize_text(value)
      I18n.transliterate(value.to_s).downcase.gsub(/[^a-z0-9]+/, " ").squish
    end
  end
end
