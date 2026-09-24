require "nokogiri"
require "pathname"
require "zip"

module BolaCinco
  class TeamRosterSpreadsheet
    class InvalidFile < StandardError; end

    MAX_BYTES = 5.megabytes
    MAX_ROWS = 2_000
    HEADERS = %w[equipe numero nome rg cpf dnascimento].freeze

    def self.read(upload)
      raise InvalidFile, "Selecione uma planilha .xlsx de até 5 MB." unless upload.respond_to?(:tempfile) &&
        File.extname(upload.original_filename).downcase == ".xlsx" && upload.size <= MAX_BYTES

      new(upload.tempfile.path).rows
    end

    def initialize(path)
      @path = path
    end

    def rows
      Zip::File.open(@path) do |zip|
        if zip.entries.size > 1_500 || zip.entries.sum(&:size) > 30.megabytes
          raise InvalidFile, "Planilha muito grande. Utilize um arquivo com até #{MAX_ROWS} linhas."
        end

        workbook = xml(zip, "xl/workbook.xml")
        sheet = workbook.xpath("//*[local-name()='sheet']").first
        raise InvalidFile, "A planilha precisa ter uma aba com os atletas." unless sheet

        relation_id = sheet.attribute_nodes.find { |attribute| attribute.name == "id" }&.value
        relation = xml(zip, "xl/_rels/workbook.xml.rels").xpath("//*[local-name()='Relationship']")
          .find { |node| node["Id"] == relation_id && node["TargetMode"] != "External" }
        raise InvalidFile, "A aba da planilha é inválida." unless relation

        target = relation["Target"].to_s
        target = target.start_with?("/") ? target.delete_prefix("/") : Pathname.new("xl").join(target).cleanpath.to_s
        raise InvalidFile, "A aba da planilha é inválida." unless target.start_with?("xl/") && !target.include?("..")

        strings = if zip.find_entry("xl/sharedStrings.xml")
          xml(zip, "xl/sharedStrings.xml").xpath("//*[local-name()='si']").map { |node| text(node) }
        else
          []
        end
        sheet_rows = xml(zip, target).xpath("//*[local-name()='sheetData']/*[local-name()='row']")
        header = sheet_rows.find { |row| row["r"] == "1" }
        unless header && normalized_headers(cells(header, strings)).first(HEADERS.length) == HEADERS
          raise InvalidFile, "Cabeçalho inválido. Use as colunas equipe, numero, nome, RG, CPF e D.Nascimento."
        end

        result = sheet_rows.filter_map do |row|
          next if row["r"].to_i <= 1

          values = cells(row, strings)
          next if values.all? { |value, error| value.blank? && error.blank? }

          {
            "line" => row["r"].to_i,
            "team_name" => values[0][0],
            "shirt_number" => values[1][0],
            "athlete_name" => values[2][0],
            "rg" => values[3][0],
            "cpf" => values[4][0],
            "birth_date" => values[5][0],
            "file_error" => values.filter_map(&:last).first
          }
        end

        raise InvalidFile, "A planilha está vazia." if result.empty?
        raise InvalidFile, "Importe no máximo #{MAX_ROWS} linhas por vez." if result.size > MAX_ROWS

        result
      end
    rescue Zip::Error, Nokogiri::XML::SyntaxError, KeyError, ArgumentError, TypeError
      raise InvalidFile, "Não foi possível ler o Excel. Salve como .xlsx usando o modelo disponível."
    end

    private

    def xml(zip, name)
      entry = zip.find_entry(name)
      raise InvalidFile, "Arquivo Excel incompleto." unless entry

      content = entry.get_input_stream.read(30.megabytes + 1)
      raise InvalidFile, "Planilha muito grande." if content.bytesize > 30.megabytes

      Nokogiri::XML(content) { |config| config.strict.nonet }
    end

    def text(node)
      node.xpath(".//*[local-name()='t']").map(&:text).join
    end

    def normalized_headers(values)
      values.map { |value, _error| normalize_header(value) }
    end

    def normalize_header(value)
      I18n.transliterate(value.to_s).downcase.gsub(/[^a-z0-9]+/, "")
    end

    def normalize_rg(value)
      value.to_s.strip.gsub(/[^0-9a-z]/i, "").downcase
    end

    def excel_serial_to_date(value)
      days = Float(value)
      Date.new(1899, 12, 30) + days.to_i
    rescue ArgumentError, TypeError
      nil
    end

    def parse_birth_date(value)
      text = value.to_s.strip
      return nil if text.blank?

      begin
        if text.match?(/\A\d+\z/)
          excel_serial_to_date(text)
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

    def cells(row, strings)
      values = Array.new(6) { ["", nil] }
      is_header_row = row["r"].to_i <= 1

      row.xpath("./*[local-name()='c']").each do |cell|
        column = cell["r"].to_s[/\A[A-Z]+/]
        index = %w[A B C D E F].index(column)
        next unless index

        if cell.at_xpath("./*[local-name()='f']") || cell["t"] == "e"
          values[index] = ["", "Substitua fórmulas ou erros por texto simples."]
          next
        end

        raw = cell.at_xpath("./*[local-name()='v']")&.text.to_s
        value = case cell["t"]
        when "s"
          strings.fetch(Integer(raw))
        when "inlineStr"
          text(cell)
        else
          raw
        end

        value = value.to_s.squish
        value = parse_birth_date(value).to_s if index == 5 && value.present? && !is_header_row
        values[index] = [value, nil]
      end
      values
    end
  end
end
