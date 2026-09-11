require "prawn"

module BolaCinco
  class TrancaStandingsDocument
    include ChampionshipLogoPdf

    def initialize(championship, groups:, duplas:)
      @championship = championship
      @groups = groups
      @duplas = duplas.to_a
    end

    def render
      @pdf = Prawn::Document.new(page_size: "A4", margin: [ 32, 28, 40, 28 ])
      @pdf.font "Helvetica"
      start_section("Classificação")
      position = 0

      if @groups.empty?
        @pdf.text "Sem classificação consolidada.", size: 11
      end

      @groups.each do |group|
        title = [ group.category.name, group.group_key.presence ].compact.join(" · ")
        rows = group.rows.map do |row|
          position += 1
          [
            position,
            row.tranca_dupla.name,
            row.played,
            row.wins,
            row.goals_for,
            row.goals_against,
            row.goal_diff,
            row.points
          ]
        end
        draw_table(title, [ "#", "Dupla", "J", "V", "PTS PRÓ", "PTS CONTRA", "SALDO", "PTS" ],
          tranca_standings_widths, rows)
      end

      @pdf.start_new_page
      start_section("Participantes")
      if @duplas.empty?
        @pdf.text "Nenhuma dupla cadastrada.", size: 11
      end
      @duplas.group_by(&:category).each do |category, pairs|
        rows = pairs.each_with_index.map do |pair, index|
          names = pair.integrante_names
          [ index + 1, pair.name, names.any? ? names.join("\n") : pair.name ]
        end
        draw_table(category.name, [ "#", "Dupla", "Participantes" ],
          [ 28, (@pdf.bounds.width - 28) / 2, (@pdf.bounds.width - 28) / 2 ], rows)
      end

      @pdf.number_pages "Página <page> de <total>", at: [ 0, -16 ],
        width: @pdf.bounds.width, align: :right, size: 8
      @pdf.render
    end

    private

    def start_section(title)
      @section = title
      @pdf.fill_color "111827"
      draw_header_logo
      @pdf.text_box @championship.name, at: [ 0, @pdf.bounds.top - 8 ], width: @pdf.bounds.width - 120, size: 15, style: :bold, align: :center
      @pdf.move_down 6
      @pdf.text_box title, at: [ 0, @pdf.bounds.top - 28 ], width: @pdf.bounds.width - 120, size: 12, style: :bold, align: :center
      @pdf.move_down 4
      @pdf.text_box "Emitido em #{Time.current.strftime("%d/%m/%Y %H:%M")}", at: [ 0, @pdf.bounds.top - 44 ], width: @pdf.bounds.width - 120, size: 8, align: :center
      @pdf.move_down 18
    end

    def draw_header_logo
      with_championship_logo(@championship) do |logo_path|
        @pdf.image logo_path, at: [ @pdf.bounds.width - 88, @pdf.bounds.top - 2 ], fit: [ 80, 36 ]
      end
    end

    def tranca_standings_widths
      [
        28,
        @pdf.bounds.width - 290,
        32,
        32,
        62,
        62,
        42,
        32
      ]
    end

    def draw_table(title, headers, widths, rows)
      title_height = @pdf.height_of(title, size: 11, style: :bold) + 8
      first_row_height = rows.first ? row_height(rows.first, widths) : 0
      next_page if @pdf.cursor < title_height + 26 + first_row_height
      draw_table_header(title, headers, widths)

      rows.each_with_index do |values, index|
        height = row_height(values, widths)
        if @pdf.cursor < height
          next_page
          draw_table_header(title, headers, widths)
        end
        draw_row(values, widths, height, fill: index.even? ? "FFFFFF" : "F3F4F6")
      end
      @pdf.move_down 16
    end

    def next_page
      @pdf.start_new_page
      start_section(@section)
    end

    def draw_table_header(title, headers, widths)
      @pdf.text title, size: 11, style: :bold
      @pdf.move_down 8
      draw_row(headers, widths, 26, fill: "FEF3C7", style: :bold)
    end

    def row_height(values, widths)
      heights = values.each_with_index.map do |value, index|
        @pdf.height_of(value.to_s, width: widths[index] - 10, size: 9)
      end
      [ heights.max + 12, 28 ].max
    end

    def draw_row(values, widths, height, fill:, style: :normal)
      top = @pdf.cursor
      left = 0
      values.each_with_index do |value, index|
        width = widths[index]
        @pdf.fill_color fill
        @pdf.stroke_color "D1D5DB"
        @pdf.line_width 0.5
        @pdf.fill_and_stroke_rectangle [ left, top ], width, height
        @pdf.fill_color "111827"
        @pdf.text_box value.to_s, at: [ left + 5, top - 6 ], width: width - 10,
          height: height - 10, size: 9, style: style
        left += width
      end
      @pdf.move_cursor_to top - height
    end
  end
end
