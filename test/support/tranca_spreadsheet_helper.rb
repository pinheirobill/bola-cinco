require "zip"
require "tempfile"

module TrancaSpreadsheetHelper
  def spreadsheet_upload(rows, headers: Tranca::DuplasSpreadsheet::HEADERS, formulas: false, shared: false)
    values = [headers, *rows]
    strings = values.flatten.map(&:to_s).uniq
    sheet_rows = values.each_with_index.map do |row, index|
      cells = row.each_with_index.map do |value, column|
        reference = "#{('A'.ord + column).chr}#{index + 1}"
        if formulas && index == 1 && column == 0
          %(<c r="#{reference}"><f>1+1</f><v>2</v></c>)
        elsif shared
          %(<c r="#{reference}" t="s"><v>#{strings.index(value.to_s)}</v></c>)
        else
          %(<c r="#{reference}" t="inlineStr"><is><t>#{ERB::Util.html_escape(value.to_s)}</t></is></c>)
        end
      end.join
      %(<row r="#{index + 1}">#{cells}</row>)
    end.join
    files = {
      "xl/workbook.xml" => '<workbook xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Duplas" r:id="rId1"/></sheets></workbook>',
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
    file = Tempfile.new(["duplas", ".xlsx"])
    file.binmode
    file.write(buffer.string)
    file.rewind
    (@spreadsheet_files ||= []) << file
    ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: "duplas.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  end

  def cleanup_spreadsheets
    @spreadsheet_files&.each(&:close!)
  end
end
