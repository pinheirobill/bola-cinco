require "zip"
require "cgi"

module Tranca
  class RoundGamesSpreadsheet
    TITLE = "RELAÇÃO DE MESAS COM CHAVES E PARTICIPANTES".freeze
    HEADERS = [ "CHAVE", "MESA", "JOGO", "DUPLA 01" ].freeze
    XMLNS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main".freeze
    ORDER_MESA = :mesa
    ORDER_NAME = :name

    def initialize(round, matches, order: ORDER_MESA)
      @round = round
      @matches = matches
      @order = order.to_sym
    end

    def render
      rows = [ [title_text] ]
      rows << HEADERS
      rows.concat(sorted_rows.map { |row| [ row[:group], row[:mesa], row[:jogo], row[:dupla] ] })

      Zip::OutputStream.write_buffer do |zip|
        package_parts(rows).each do |name, content|
          zip.put_next_entry(name)
          zip.write(content)
        end
      end.string
    end

    private

    attr_reader :round, :matches, :order

    def sorted_rows
      rows = matches.flat_map do |match|
        pair_rows_for(match)
      end

      case order
      when ORDER_NAME
        rows.sort_by { |row| [ row[:dupla].to_s.downcase, row[:group_sort], row[:mesa_sort], row[:jogo_sort], row[:side_sort] ] }
      else
        rows.sort_by { |row| [ row[:group_sort], row[:mesa_sort], row[:jogo_sort], row[:side_sort], row[:dupla].to_s.downcase ] }
      end
    end

    def pair_rows_for(match)
      dupla_rows = [
        { dupla: match.dupla_a_nome, side_sort: 0 },
        { dupla: match.dupla_b_nome, side_sort: 1 }
      ]

      dupla_rows.filter_map do |row|
        name = row[:dupla].to_s.squish
        next if name.blank?

        group_label = group_label_for(match)
        mesa_label = mesa_label_for(match)
        jogo_label = game_label_for(match)
        row.merge(
          group: group_label,
          mesa: mesa_label,
          jogo: jogo_label,
          group_sort: sort_key_for_label(group_label),
          mesa_sort: sort_key_for_label(mesa_label),
          jogo_sort: sort_key_for_label(jogo_label)
        )
      end
    end

    def title_text
      matches.first&.championship&.name.presence || round&.label.presence || round&.phase_label.presence || TITLE
    end

    def group_label_for(match)
      label = match.group_key.to_s.squish
      label = label.sub(/\ACHAVE\s+/i, "").squish
      label.presence || "-"
    end

    def mesa_label_for(match)
      source = match.tranca_mesa&.code.to_s.squish
      source = match.tranca_mesa&.name.to_s.squish if source.blank?
      numeric = source.scan(/\d+/).last
      numeric.presence || source.presence || "-"
    end

    def game_label_for(match)
      if match.respond_to?(:game_number_label)
        match.game_number_label.to_s.squish.presence || "-"
      else
        match.code.to_s.squish.presence || "-"
      end
    end

    def sort_key_for_label(value)
      text = value.to_s.squish
      return [ 0, 0 ] if text.blank? || text == "-"
      return [ 0, text.to_i ] if text.match?(/\A\d+\z/)

      [ 1, text.downcase ]
    end

    def escape(value)
      CGI.escapeHTML(value.to_s.gsub(/[\x00-\x08\x0B\x0C\x0E-\x1F]/, ""))
    end

    def worksheet(rows)
      body = rows.each_with_index.map do |values, row_index|
        cells = values.each_with_index.map do |value, column|
          ref = "#{(65 + column).chr}#{row_index + 1}"
          style = style_for_row(row_index, column)
          if value.is_a?(Numeric)
            %(<c r="#{ref}"#{style}><v>#{value}</v></c>)
          else
            %(<c r="#{ref}" t="inlineStr"#{style}><is><t xml:space="preserve">#{escape(value)}</t></is></c>)
          end
        end.join
        row_height = row_index.zero? ? ' ht="24" customHeight="1"' : row_index == 1 ? ' ht="20" customHeight="1"' : ' ht="18" customHeight="1"'
        %(<row r="#{row_index + 1}"#{row_height}>#{cells}</row>)
      end.join

      data_end = rows.size
      %(<?xml version="1.0" encoding="UTF-8"?>
<worksheet xmlns="#{XMLNS}">
  <dimension ref="A1:D#{data_end}"/>
  <sheetViews>
    <sheetView workbookViewId="0">
      <pane ySplit="2" topLeftCell="A3" activePane="bottomLeft" state="frozen"/>
    </sheetView>
  </sheetViews>
  <sheetFormatPr defaultRowHeight="18"/>
  <cols>
    <col min="1" max="1" width="12" customWidth="1"/>
    <col min="2" max="3" width="12" customWidth="1"/>
    <col min="4" max="4" width="60" customWidth="1"/>
  </cols>
  <sheetData>#{body}</sheetData>
  <mergeCells count="1"><mergeCell ref="A1:D1"/></mergeCells>
  <autoFilter ref="A2:D#{data_end}"/>
</worksheet>)
    end

    def style_for_row(row_index, column)
      return ' s="2"' if row_index.zero?
      return ' s="3"' if row_index == 1
      return ' s="4"' if row_index.even?

      ' s="5"'
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
          <styleSheet xmlns="#{XMLNS}">
            <fonts count="3">
              <font><sz val="11"/><name val="Calibri"/></font>
              <font><b/><sz val="16"/><name val="Calibri"/></font>
              <font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font>
            </fonts>
            <fills count="5">
              <fill><patternFill patternType="none"/></fill>
              <fill><patternFill patternType="gray125"/></fill>
              <fill><patternFill patternType="solid"><fgColor rgb="FFB4C6E7"/><bgColor indexed="64"/></patternFill></fill>
              <fill><patternFill patternType="solid"><fgColor rgb="FF8EA9DB"/><bgColor indexed="64"/></patternFill></fill>
              <fill><patternFill patternType="solid"><fgColor rgb="FFF3F4F6"/><bgColor indexed="64"/></patternFill></fill>
            </fills>
            <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
            <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
            <cellXfs count="6">
              <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="center" horizontal="left"/></xf>
              <xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment vertical="center" horizontal="center"/></xf>
              <xf numFmtId="0" fontId="2" fillId="3" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment vertical="center" horizontal="center"/></xf>
              <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="center" horizontal="center"/></xf>
              <xf numFmtId="0" fontId="0" fillId="4" borderId="0" xfId="0" applyFill="1" applyAlignment="1"><alignment vertical="center" horizontal="left"/></xf>
              <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="center" horizontal="left"/></xf>
            </cellXfs>
            <cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
          </styleSheet>
        XML
        "xl/worksheets/sheet1.xml" => worksheet(rows)
      }
    end
  end
end
