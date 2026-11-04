require "nokogiri"
require "pathname"
require "zip"

module BolaCinco
  class TeamRosterSpreadsheet
    class InvalidFile < StandardError; end

    MAX_BYTES = 5.megabytes
    MAX_ROWS = 2_000
    MAX_COLUMNS = 64
    HEADERS = %w[equipe numero nome rg cpf dnascimento].freeze
    HEADER_ALIASES = {
      "team_name" => %w[equipe time],
      "shirt_number" => %w[numero numerocamisa ncamisa camisa],
      "athlete_name" => %w[nome nomecompleto atleta],
      "rg" => %w[rg],
      "cpf" => %w[cpf],
      "birth_date" => %w[dnascimento datanascimento datadenascimento nascimento],
      "email" => %w[email],
      "cell_phone" => %w[celular telefone telefonecelular],
      "birth_certificate" => %w[certidaonascimento certidaodenascimento],
      "position" => %w[posicao],
      "passport" => %w[passaporte],
      "voter_id" => %w[tituloeleitor titulodeeleitor],
      "gender" => %w[genero sexo],
      "document" => %w[documento outrodocumento]
    }.freeze

    def self.read(upload, require_team: true)
      raise InvalidFile, "Selecione uma planilha .xlsx de até 5 MB." unless upload.respond_to?(:tempfile) && upload.tempfile.present?
      raise InvalidFile, "O arquivo precisa estar no formato .xlsx." unless File.extname(upload.original_filename).downcase == ".xlsx"
      raise InvalidFile, "A planilha deve ter até 5 MB." if upload.size > MAX_BYTES

      new(upload.tempfile.path).rows(require_team: require_team)
    end

    def initialize(path)
      @path = path
    end

    def rows(require_team: true)
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
        raise InvalidFile, "A planilha precisa ter cabeçalhos na primeira linha." unless header

        header_names = normalized_headers(cells(header, strings))
        columns = HEADER_ALIASES.transform_values do |aliases|
          header_names.index { |name| aliases.include?(name) }
        end
        unless columns["athlete_name"] && (!require_team || columns["team_name"])
          required = require_team ? "equipe e nome" : "nome"
          raise InvalidFile, "Cabeçalho inválido. Inclua as colunas #{required}."
        end

        result = sheet_rows.filter_map do |row|
          next if row["r"].to_i <= 1

          values = cells(row, strings, birth_date_column: columns["birth_date"])
          next if values.all? { |value, error| value.blank? && error.blank? }

          HEADER_ALIASES.keys.index_with do |field|
            index = columns[field]
            value = index ? values.dig(index, 0).to_s : ""
            %w[rg cpf].include?(field) ? normalize_rg(value) : value
          end.merge(
            "line" => row["r"].to_i,
            "file_error" => columns.values.compact.filter_map { |index| values.dig(index, 1) }.first
          )
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

    def cells(row, strings, birth_date_column: nil)
      values = []
      is_header_row = row["r"].to_i <= 1

      row.xpath("./*[local-name()='c']").each do |cell|
        column = cell["r"].to_s[/\A[A-Z]{1,3}/]
        next unless column
        index = column.each_char.reduce(0) { |number, letter| number * 26 + letter.ord - "A".ord + 1 } - 1
        next if index >= MAX_COLUMNS

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
        value = parse_birth_date(value).to_s if index == birth_date_column && value.present? && !is_header_row
        values[index] = [value, nil]
      end
      values.map { |value| value || ["", nil] }
    end
  end
end
