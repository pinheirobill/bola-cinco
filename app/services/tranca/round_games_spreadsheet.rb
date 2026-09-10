require "zip"
require "cgi"

module Tranca
  class RoundGamesSpreadsheet
    HEADERS = ["Campeonato", "Rodada", "Fase", "Categoria", "Jogo", "Mesa", "Data", "Horário", "Dupla A", "Dupla B", "Pontos A", "Pontos B", "Status"].freeze
    XMLNS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main".freeze

    def initialize(round, matches)
      @round, @matches = round, matches
    end

    def render
      rows = [HEADERS] + @matches.map do |match|
        hands = match.maos.to_a
        score_a = hands.empty? ? match[:score_a] : hands.sum { |hand| hand.pontos_a.to_i }
        score_b = hands.empty? ? match[:score_b] : hands.sum { |hand| hand.pontos_b.to_i }
        [match.championship.name, @round.round_number, @round.phase_label, match.category.name,
          match.code, match.tranca_mesa&.name, match.scheduled_on&.strftime("%d/%m/%Y"),
          match.scheduled_time, match.dupla_a_nome, match.dupla_b_nome,
          score_a, score_b, match.status.humanize]
      end
      Zip::OutputStream.write_buffer do |zip|
        package_parts(rows).each do |name, content|
          zip.put_next_entry(name)
          zip.write(content)
        end
      end.string
    end

    private

    def escape(value)
      CGI.escapeHTML(value.to_s.gsub(/[\x00-\x08\x0B\x0C\x0E-\x1F]/, ""))
    end

    def worksheet(rows)
      body = rows.each_with_index.map do |values, row_index|
        cells = values.each_with_index.map do |value, column|
          ref = "#{(65 + column).chr}#{row_index + 1}"
          style = row_index.zero? ? ' s="1"' : ""
          if value.is_a?(Numeric)
            %(<c r="#{ref}"#{style}><v>#{value}</v></c>)
          else
            # Explicit string cells keep names beginning with =, +, - or @ as text.
            %(<c r="#{ref}" t="inlineStr"#{style}><is><t xml:space="preserve">#{escape(value)}</t></is></c>)
          end
        end.join
        %(<row r="#{row_index + 1}">#{cells}</row>)
      end.join
      %(<?xml version="1.0" encoding="UTF-8"?><worksheet xmlns="#{XMLNS}"><dimension ref="A1:M#{rows.size}"/><sheetViews><sheetView workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews><cols><col min="1" max="1" width="28" customWidth="1"/><col min="2" max="8" width="20" customWidth="1"/><col min="9" max="10" width="55" customWidth="1"/><col min="11" max="13" width="16" customWidth="1"/></cols><sheetData>#{body}</sheetData><autoFilter ref="A1:M#{rows.size}"/></worksheet>)
    end

    def package_parts(rows)
      {
        "[Content_Types].xml" => <<~XML,
          <?xml version="1.0" encoding="UTF-8"?>
          <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/></Types>
        XML
        "_rels/.rels" => <<~XML,
          <?xml version="1.0" encoding="UTF-8"?>
          <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>
        XML
        "xl/workbook.xml" => <<~XML,
          <?xml version="1.0" encoding="UTF-8"?>
          <workbook xmlns="#{XMLNS}" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Jogos" sheetId="1" r:id="rId1"/></sheets></workbook>
        XML
        "xl/_rels/workbook.xml.rels" => <<~XML,
          <?xml version="1.0" encoding="UTF-8"?>
          <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>
        XML
        "xl/styles.xml" => <<~XML,
          <?xml version="1.0" encoding="UTF-8"?>
          <styleSheet xmlns="#{XMLNS}"><fonts count="2"><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font></fonts><fills count="3"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill><fill><patternFill patternType="solid"><fgColor rgb="FF1F2937"/><bgColor indexed="64"/></patternFill></fill></fills><borders count="1"><border/></borders><cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs><cellXfs count="2"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/><xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1"/></cellXfs><cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles></styleSheet>
        XML
        "xl/worksheets/sheet1.xml" => worksheet(rows)
      }
    end
  end
end
