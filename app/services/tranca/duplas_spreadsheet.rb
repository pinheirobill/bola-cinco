require "zip"
require "nokogiri"
require "pathname"

module Tranca
  class DuplasSpreadsheet
    class InvalidFile < StandardError; end

    MAX_BYTES = 2.megabytes
    MAX_ROWS = 500
    HEADERS = ["Participante 1", "Participante 2", "Nome da dupla (opcional)"].freeze

    def self.read(upload)
      raise InvalidFile, "Selecione uma planilha .xlsx de até 2 MB." unless upload.respond_to?(:tempfile) &&
        File.extname(upload.original_filename).downcase == ".xlsx" && upload.size <= MAX_BYTES

      new(upload.tempfile.path).rows
    end

    def initialize(path)
      @path = path
    end

    def rows
      Zip::File.open(@path) do |zip|
        if zip.entries.size > 1_000 || zip.entries.sum(&:size) > 20.megabytes
          raise InvalidFile, "Planilha muito grande. Utilize o modelo com até #{MAX_ROWS} duplas."
        end

        workbook = xml(zip, "xl/workbook.xml")
        sheet = workbook.xpath("//*[local-name()='sheet']").find { |node| node["name"] == "Duplas" }
        raise InvalidFile, "A planilha precisa ter uma aba chamada Duplas." unless sheet

        relation_id = sheet.attribute_nodes.find { |attribute| attribute.name == "id" }&.value
        relation = xml(zip, "xl/_rels/workbook.xml.rels").xpath("//*[local-name()='Relationship']")
          .find { |node| node["Id"] == relation_id && node["TargetMode"] != "External" }
        raise InvalidFile, "A aba Duplas é inválida." unless relation

        target = relation["Target"].to_s
        target = target.start_with?("/") ? target.delete_prefix("/") : Pathname.new("xl").join(target).cleanpath.to_s
        raise InvalidFile, "A aba Duplas é inválida." unless target.start_with?("xl/") && !target.include?("..")

        strings = if zip.find_entry("xl/sharedStrings.xml")
          xml(zip, "xl/sharedStrings.xml").xpath("//*[local-name()='si']").map { |node| text(node) }
        else
          []
        end
        sheet_rows = xml(zip, target).xpath("//*[local-name()='sheetData']/*[local-name()='row']")
        header = sheet_rows.find { |row| row["r"] == "1" }
        unless header && cells(header, strings).map(&:first) == HEADERS
          raise InvalidFile, "Cabeçalho inválido. Baixe o modelo e mantenha as três primeiras colunas."
        end

        result = sheet_rows.filter_map do |row|
          next if row["r"].to_i <= 1

          values = cells(row, strings)
          next if values.all? { |value, error| value.blank? && error.blank? }

          { "line" => row["r"].to_i, "participant_one" => values[0][0], "participant_two" => values[1][0],
            "name" => values[2][0], "file_error" => values.filter_map(&:last).first }
        end
        raise InvalidFile, "A planilha está vazia." if result.empty?
        raise InvalidFile, "Importe no máximo #{MAX_ROWS} duplas por vez." if result.size > MAX_ROWS

        result
      end
    rescue Zip::Error, Nokogiri::XML::SyntaxError, KeyError, ArgumentError, TypeError
      raise InvalidFile, "Não foi possível ler o Excel. Salve como .xlsx usando o modelo disponível."
    end

    private

    def xml(zip, name)
      entry = zip.find_entry(name)
      raise InvalidFile, "Arquivo Excel incompleto." unless entry

      content = entry.get_input_stream.read(20.megabytes + 1)
      raise InvalidFile, "Planilha muito grande." if content.bytesize > 20.megabytes

      Nokogiri::XML(content) { |config| config.strict.nonet }
    end

    def text(node)
      node.xpath(".//*[local-name()='t']").map(&:text).join
    end

    def cells(row, strings)
      values = Array.new(3) { ["", nil] }
      row.xpath("./*[local-name()='c']").each do |cell|
        column = cell["r"].to_s[/\A[A-Z]+/]
        index = %w[A B C].index(column)
        next unless index

        if cell.at_xpath("./*[local-name()='f']") || cell["t"] == "e"
          values[index] = ["", "Substitua fórmulas ou erros por nomes em texto."]
          next
        end
        raw = cell.at_xpath("./*[local-name()='v']")&.text.to_s
        value = case cell["t"]
        when "s" then strings.fetch(Integer(raw))
        when "inlineStr" then text(cell)
        else raw
        end
        values[index] = [value.to_s.squish, nil]
      end
      values
    end
  end
end
