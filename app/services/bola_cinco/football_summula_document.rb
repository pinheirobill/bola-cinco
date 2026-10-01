require "prawn"

module BolaCinco
  class FootballSummulaDocument
    PAGE_SIZE = "A4".freeze
    PAGE_MARGIN = 24
    ROSTER_ROWS = 18

    def self.render_all(matches)
      Prawn::Document.new(page_size: PAGE_SIZE, margin: PAGE_MARGIN, page_layout: :landscape) do |pdf|
        matches.each_with_index do |match, index|
          pdf.start_new_page if index.positive?
          new(match).render_page(pdf)
        end
      end.render
    end

    def initialize(match)
      @match = match
    end

    def render_page(pdf)
      pdf.font("Helvetica")
      pdf.text(match.championship.name, size: 17, style: :bold, align: :center)
      pdf.move_down 3
      pdf.text("SÚMULA DA PARTIDA", size: 12, style: :bold, align: :center)
      pdf.move_down 10
      draw_match_details(pdf)
      pdf.move_down 10
      draw_team_rosters(pdf)
      pdf.move_down 10
      draw_events_area(pdf)
      pdf.move_down 9
      draw_signatures(pdf)
    end

    private

    attr_reader :match

    def draw_match_details(pdf)
      rows = [
        ["Código", match.code, "Categoria", match.category&.name.to_s],
        ["Fase / rodada", [match.phase.to_s.humanize, ("Rodada #{match.round_number}" if match.round_number.present?)].compact.join(" · "), "Grupo", match.group_key.to_s],
        ["Data", match.scheduled_on&.strftime("%d/%m/%Y").presence || "________________", "Horário / local", [match.scheduled_time&.strftime("%H:%M"), match.venue_name.presence].compact.join(" · ").presence || "________________"]
      ]
      widths = [82, 280, 82, pdf.bounds.width - 444]
      row_height = 19
      top = pdf.cursor
      rows.each_with_index do |row, row_index|
        y = top - row_index * row_height
        x = 0
        row.each_with_index do |value, column_index|
          width = widths[column_index]
          pdf.fill_color(column_index.even? ? "E8EDF3" : "FFFFFF")
          pdf.fill_rectangle([x, y], width, row_height)
          pdf.stroke_color "A0A0A0"
          pdf.stroke_rectangle([x, y], width, row_height)
          pdf.fill_color "1F2937"
          pdf.text_box(value.to_s, at: [x + 4, y - 3], width: width - 8, height: row_height - 5,
            size: column_index.even? ? 8 : 9, style: column_index.even? ? :bold : :normal,
            valign: :center, overflow: :shrink_to_fit, min_font_size: 6)
          x += width
        end
      end
      pdf.move_down(row_height * rows.size)
      pdf.move_down 5
      pdf.text("#{match.team_a_label}   ×   #{match.team_b_label}", size: 13, style: :bold, align: :center)
    end

    def draw_team_rosters(pdf)
      left = roster_rows(match.team_a)
      right = roster_rows(match.team_b)
      widths = [34, (pdf.bounds.width - 68) / 2.0, 34, (pdf.bounds.width - 68) / 2.0]
      row_height = 13
      header = ["Nº", match.team_a_label, "Nº", match.team_b_label]
      draw_grid_row(pdf, header, widths, row_height + 5, header: true)
      ROSTER_ROWS.times do |index|
        draw_grid_row(pdf, [left[index]&.first.to_s, left[index]&.last.to_s, right[index]&.first.to_s, right[index]&.last.to_s], widths, row_height)
      end
    end

    def draw_events_area(pdf)
      widths = [pdf.bounds.width * 0.4, pdf.bounds.width * 0.2, pdf.bounds.width * 0.4]
      draw_grid_row(pdf, ["Gols / minuto", "Cartões", "Substituições / minuto"], widths, 18, header: true)
      draw_grid_row(pdf, ["", "", ""], widths, 34)
      pdf.move_down 4
      pdf.text("Placar: #{match.score_a.presence || "___"} × #{match.score_b.presence || "___"}     Árbitro: #{match.match_report&.referee&.name.presence || "________________________________"}", size: 9)
      pdf.move_down 5
      pdf.text("Observações: ______________________________________________________________________________________________________________", size: 8)
    end

    def draw_signatures(pdf)
      pdf.text("\n______________________________________________                               ______________________________________________", size: 9, align: :center)
      pdf.text("Assinatura da arbitragem                                                     Responsável pela mesa", size: 8, align: :center)
    end

    def roster_rows(team)
      team&.athletes&.sort_by { |athlete| [athlete.shirt_number.to_i.zero? ? Float::INFINITY : athlete.shirt_number.to_i, athlete.name.to_s.downcase] }&.first(ROSTER_ROWS)&.map do |athlete|
        [athlete.shirt_number, athlete.name]
      end || []
    end

    def draw_grid_row(pdf, values, widths, height, header: false)
      top = pdf.cursor
      x = 0
      values.each_with_index do |value, index|
        width = widths[index]
        pdf.fill_color(header ? "E8EDF3" : "FFFFFF")
        pdf.fill_rectangle([x, top], width, height)
        pdf.stroke_color "A0A0A0"
        pdf.stroke_rectangle([x, top], width, height)
        pdf.fill_color "1F2937"
        pdf.text_box(value.to_s, at: [x + 3, top - 2], width: width - 6, height: height - 4,
          size: 8, style: header ? :bold : :normal, valign: :center,
          overflow: :shrink_to_fit, min_font_size: 6)
        x += width
      end
      pdf.move_down height
    end
  end
end
