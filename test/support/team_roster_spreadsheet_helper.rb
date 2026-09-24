require "zip"
require "tempfile"

module TeamRosterSpreadsheetHelper
  def roster_spreadsheet_upload(rows, headers: %w[equipe numero nome RG CPF D.Nascimento], shared: false)
    values = [headers, *rows]
    strings = values.flatten.map(&:to_s).uniq
    sheet_rows = values.each_with_index.map do |row, index|
      cells = row.each_with_index.map do |value, column|
        reference = "#{('A'.ord + column).chr}#{index + 1}"
        if shared
          %(<c r="#{reference}" t="s"><v>#{strings.index(value.to_s)}</v></c>)
        else
          %(<c r="#{reference}" t="inlineStr"><is><t>#{ERB::Util.html_escape(value.to_s)}</t></is></c>)
        end
      end.join
      %(<row r="#{index + 1}">#{cells}</row>)
    end.join
    files = {
      "xl/workbook.xml" => '<workbook xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Atletas" r:id="rId1"/></sheets></workbook>',
      "xl/_rels/workbook.xml.rels" => '<Relationships><Relationship Id="rId1" Target="worksheets/sheet1.xml"/></Relationships>',
      "xl/worksheets/sheet1.xml" => "<worksheet><sheetData>#{sheet_rows}</sheetData></worksheet>"
    }
    files["xl/sharedStrings.xml"] = "<sst>#{strings.map { |value| "<si><t>#{ERB::Util.html_escape(value)}</t></si>" }.join}</sst>" if shared
    buffer = Zip::OutputStream.write_buffer do |zip|
      files.each do |name, content|
        zip.put_next_entry(name)
        zip.write(content)
      end
    end
    file = Tempfile.new(["equipes", ".xlsx"])
    file.binmode
    file.write(buffer.string)
    file.rewind
    (@spreadsheet_files ||= []) << file
    ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: "equipes.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  end

  def cleanup_spreadsheets
    @spreadsheet_files&.each(&:close!)
  end
end
