require "prawn"

module BolaCinco
  class TrancaProgramacaoDocument
    include ChampionshipLogoPdf

    PAGE_SIZE = "A4".freeze
    FONT_NORMAL = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf".freeze
    FONT_BOLD = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf".freeze

    def initialize(presenter)
      @presenter = presenter
    end

    def render
      @pdf = Prawn::Document.new(page_size: PAGE_SIZE, margin: [ 32, 28, 40, 28 ])
      @pdf.font_families.update(
        "DejaVu Sans" => {
          normal: FONT_NORMAL,
          bold: FONT_BOLD
        }
      )
      @pdf.font "DejaVu Sans"
      render_document
      @pdf.number_pages "Página <page> de <total>", at: [ 0, -16 ], width: @pdf.bounds.width, align: :right, size: 8
      @pdf.render
    end

    private

    attr_reader :presenter

    def render_document
      start_section
      presenter.sections.each_with_index do |section, index|
        next_page if index.positive? && @pdf.cursor < 90
        render_section(section)
      end
    end

    def start_section
      @section_started = true
      @pdf.fill_color "111827"
      draw_header_logo
      @pdf.text_box presenter.title, at: [ 0, @pdf.bounds.top - 8 ], width: @pdf.bounds.width - 120, size: 15, style: :bold, align: :left
      @pdf.move_down 2
      @pdf.text_box presenter.subtitle, at: [ 0, @pdf.bounds.top - 27 ], width: @pdf.bounds.width - 120, size: 11, style: :bold, align: :left
      @pdf.text_box presenter.issued_at.strftime("%d/%m/%Y %H:%M"), at: [ @pdf.bounds.width - 110, @pdf.bounds.top - 8 ], width: 110, size: 8, align: :right
      @pdf.move_down 14
    end

    def draw_header_logo
      with_championship_logo(presenter.championship) do |logo_path|
        @pdf.image logo_path, at: [ @pdf.bounds.width - 88, @pdf.bounds.top - 2 ], fit: [ 80, 36 ]
      end
    end

    def next_page
      @pdf.start_new_page
      start_section
    end

    def render_section(section)
      draw_section_separator
      draw_table_header(section[:label])
      section[:rows].each_with_index do |row, index|
        ensure_room!(row_height(row))
        draw_row(row, fill: index.even? ? "FFF7E1" : "FFFFFF")
      end
      @pdf.move_down 10
    end

    def draw_section_separator
      ensure_room!(28)
      top = @pdf.cursor
      @pdf.fill_color "102A66"
      @pdf.fill_and_stroke_rectangle [ 0, top ], @pdf.bounds.width, 10
      @pdf.move_cursor_to top - 10
    end

    def draw_table_header(label)
      top = @pdf.cursor
      widths = column_widths
      values = [ "JG", "mesa", nil, "PTS", "CHAVE #{label}", "PTS", nil ]
      draw_cells(values, widths, top, 22, fill: "F8C21C", style: :bold)
      @pdf.move_cursor_to top - 22
    end

    def draw_row(row, fill:)
      top = @pdf.cursor
      widths = column_widths
      values = [
        "JG #{row[:jg]}",
        row[:mesa],
        row[:team_a],
        row[:score_a],
        "x",
        row[:score_b],
        row[:team_b]
      ]
      draw_cells(values, widths, top, row_height(row), fill: fill, style: :normal)
      @pdf.move_cursor_to top - row_height(row)
    end

    def draw_cells(values, widths, top, height, fill:, style:)
      left = 0
      values.each_with_index do |value, index|
        width = widths[index]
        @pdf.fill_color fill
        @pdf.stroke_color "FFFFFF"
        @pdf.fill_and_stroke_rectangle [ left, top ], width, height
        unless value.to_s.strip.empty?
          @pdf.fill_color index == 4 ? "D40000" : "111827"
          @pdf.text_box value.to_s, at: [ left + 4, top - 5 ], width: width - 8, height: height - 8,
            size: index == 2 || index == 6 ? 8 : 9, style: style, overflow: :shrink_to_fit, min_font_size: 7, align: index == 4 ? :center : :left, valign: :center
        end
        left += width
      end
      @pdf.move_cursor_to top - height
    end

    def row_height(row)
      team_height = [
        @pdf.height_of(row[:team_a].to_s, width: column_widths[2] - 8, size: 8),
        @pdf.height_of(row[:team_b].to_s, width: column_widths[6] - 8, size: 8)
      ].max
      [ team_height + 10, 22 ].max
    end

    def ensure_room!(height)
      next_page if @pdf.cursor < height + 8
    end

    def column_widths
      @column_widths ||= begin
        team_width = (@pdf.bounds.width - 30 - 36 - 24 - 65 - 24) / 2.0
        [ 30, 36, team_width, 24, 65, 24, team_width ]
      end
    end
  end
end
