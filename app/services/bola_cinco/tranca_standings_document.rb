require "prawn"

module BolaCinco
  class TrancaStandingsDocument
    include ChampionshipLogoPdf
    include UiHelper

    NAVY = "082B63"
    GOLD = "F4C20D"
    TEXT = "172033"
    MUTED = "64748B"
    BORDER = "CBD5E1"
    ROW_ALT = "F1F5F9"
    FIRST_PLACE = "D8F3DC"
    FIRST_PLACE_TEXT = "166534"

    def initialize(championship, groups:)
      @championship = championship
      @groups = groups
    end

    def render
      @pdf = Prawn::Document.new(page_size: "A4", page_layout: :landscape, margin: [ 28, 32, 36, 32 ])
      @pdf.font "Helvetica"
      start_section("Classificação")

      if @groups.empty?
        @pdf.text "Sem classificação consolidada.", size: 11
      end

      classification_tables = @groups.map do |group|
        title = classification_group_title(group)
        rows = group.rows.map do |row|
          [
            row.position,
            row.tranca_dupla.name,
            row.played,
            row.wins,
            row.goals_for,
            row.goals_against,
            row.goal_diff,
            row.points
          ]
        end
        [ title, rows ]
      end
      draw_classification_tables(classification_tables)

      @pdf.start_new_page
      start_section("Ranking geral")
      ranking_rows = general_ranking_rows

      if ranking_rows.empty?
        @pdf.text "Sem classificação consolidada.", size: 11
      else
        ranking_widths = [ 34, @pdf.bounds.width - 226, 64, 72, 56 ]
        draw_table("Melhores duplas", [ "#", "Dupla", "Vitórias", "Pontos", "Saldo" ],
          ranking_widths, ranking_rows)
      end

      @pdf.number_pages "Página <page> de <total>", at: [ 0, -16 ],
        width: @pdf.bounds.width, align: :right, size: 8
      @pdf.render
    end

    private

    def classification_group_title(group)
      key_label = tranca_group_key_label(group.group_key)
      [ group.category.name, ("Chave #{key_label}" if key_label.present?) ].compact.join(" · ")
    end

    def general_ranking_rows
      @groups.flat_map(&:rows).sort_by do |row|
        [
          -row.wins.to_i,
          -row.goals_for.to_i,
          -row.goal_diff.to_i,
          row.tranca_dupla.name.to_s.downcase
        ]
      end.each_with_index.map do |row, index|
        [ index + 1, row.tranca_dupla.name, row.wins, row.goals_for, row.goal_diff ]
      end
    end

    def start_section(title)
      @section = title
      top = @pdf.bounds.top

      @pdf.fill_color NAVY
      @pdf.fill_rectangle [ 0, top ], @pdf.bounds.width, 70
      @pdf.fill_color GOLD
      @pdf.fill_rectangle [ 0, top - 70 ], @pdf.bounds.width, 5

      @pdf.fill_color "FFFFFF"
      @pdf.text_box @championship.name.to_s.upcase, at: [ 20, top - 16 ],
        width: @pdf.bounds.width - 160, height: 22, size: 16, style: :bold
      @pdf.fill_color GOLD
      @pdf.text_box title.upcase, at: [ 20, top - 41 ],
        width: @pdf.bounds.width - 160, height: 18, size: 10, style: :bold
      @pdf.fill_color "DCE7F5"
      @pdf.text_box "Emitido em #{Time.current.strftime("%d/%m/%Y às %H:%M")}", at: [ 20, top - 56 ],
        width: @pdf.bounds.width - 160, height: 12, size: 7.5

      draw_header_logo(top)
      @pdf.move_cursor_to top - 88

      return unless title == "Classificação"

      draw_legend
      @pdf.move_down 10
    end

    def draw_header_logo(top)
      with_championship_logo(@championship) do |logo_path|
        @pdf.image logo_path, at: [ @pdf.bounds.width - 112, top - 12 ], fit: [ 92, 46 ]
      end
    end

    def draw_legend
      top = @pdf.cursor
      @pdf.fill_color FIRST_PLACE
      @pdf.rounded_rectangle [ 0, top ], 15, 15, 3
      @pdf.fill
      @pdf.fill_color FIRST_PLACE_TEXT
      @pdf.text_box "1", at: [ 0, top - 3 ], width: 15, height: 12,
        size: 7.5, style: :bold, align: :center
      @pdf.fill_color MUTED
      @pdf.text_box "Primeiro lugar de cada chave", at: [ 22, top - 2 ],
        width: 180, height: 14, size: 8
      @pdf.move_cursor_to top - 15
    end

    def tranca_standings_widths(total_width = @pdf.bounds.width)
      [
        24,
        total_width - 226,
        24,
        24,
        42,
        46,
        38,
        28
      ]
    end

    def draw_classification_tables(tables)
      headers = [ "#", "Dupla", "J", "V", "PTS PRÓ", "PTS CONTRA", "SALDO", "PTS" ]
      gutter = 14
      column_width = (@pdf.bounds.width - gutter) / 2.0
      column_x = [ 0, column_width + gutter ]
      column_index = 0
      column_top = @pdf.cursor
      current_y = column_top

      tables.each do |title, rows|
        widths = tranca_standings_widths(column_width)
        height = table_height(rows, widths)

        if current_y < height
          column_index += 1
          if column_index > 1
            next_page
            column_index = 0
            column_top = @pdf.cursor
          end
          current_y = column_top
        end

        @pdf.bounding_box([ column_x[column_index], current_y ], width: column_width, height: height) do
          draw_table(title, headers, widths, rows)
        end
        current_y -= height + 12
      end
    end

    def table_height(rows, widths)
      25 + 25 + rows.sum { |row| row_height(row, widths) } + 14
    end

    def draw_table(title, headers, widths, rows)
      title_height = 25
      first_row_height = rows.first ? row_height(rows.first, widths) : 0
      next_page if @pdf.cursor < title_height + 25 + first_row_height
      draw_table_header(title, headers, widths)

      rows.each_with_index do |values, index|
        height = row_height(values, widths)
        if @pdf.cursor < height
          next_page
          draw_table_header(title, headers, widths)
        end
        draw_row(values, widths, height,
          fill: standings_row_fill(index),
          text_color: classification_first_place?(index) ? FIRST_PLACE_TEXT : TEXT,
          style: classification_first_place?(index) ? :bold : :normal)
      end
      @pdf.move_down 14
    end

    def next_page
      @pdf.start_new_page
      start_section(@section)
    end

    def draw_table_header(title, headers, widths)
      top = @pdf.cursor
      @pdf.fill_color NAVY
      @pdf.fill_rectangle [ 0, top ], @pdf.bounds.width, 25
      @pdf.fill_color GOLD
      @pdf.fill_rectangle [ 0, top ], 6, 25
      @pdf.fill_color "FFFFFF"
      @pdf.text_box title.to_s.upcase, at: [ 15, top - 7 ],
        width: @pdf.bounds.width - 25, height: 16, size: 9.5, style: :bold
      @pdf.move_cursor_to top - 25
      draw_row(headers, widths, 25, fill: GOLD, style: :bold, header: true)
    end

    def row_height(values, widths)
      heights = values.each_with_index.map do |value, index|
        @pdf.height_of(value.to_s, width: widths[index] - 10, size: 9)
      end
      [ heights.max + 11, 25 ].max
    end

    def standings_row_fill(index)
      return FIRST_PLACE if classification_first_place?(index)

      index.even? ? "FFFFFF" : ROW_ALT
    end

    def classification_first_place?(index)
      @section == "Classificação" && index.zero?
    end

    def draw_row(values, widths, height, fill:, style: :normal, text_color: TEXT, header: false)
      top = @pdf.cursor
      left = 0
      values.each_with_index do |value, index|
        width = widths[index]
        @pdf.fill_color fill
        @pdf.stroke_color BORDER
        @pdf.line_width 0.35
        @pdf.fill_and_stroke_rectangle [ left, top ], width, height
        @pdf.fill_color(header ? NAVY : text_color)
        @pdf.text_box value.to_s, at: [ left + 6, top - 6 ], width: width - 12,
          height: height - 10, size: header ? 7.5 : 8.5, style: style,
          align: cell_alignment(value, index, header: header), overflow: :shrink_to_fit
        left += width
      end
      @pdf.move_cursor_to top - height
    end

    def cell_alignment(value, index, header:)
      return :center if index.zero? || value.is_a?(Numeric)
      return :center if header && index > 1

      :left
    end
  end
end
