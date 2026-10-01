require "prawn"
require "prawn/table"

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
      pdf.table([
        ["Código", match.code, "Categoria", match.category&.name.to_s],
        ["Fase / rodada", [match.phase.to_s.humanize, ("Rodada #{match.round_number}" if match.round_number.present?)].compact.join(" · "), "Grupo", match.group_key.to_s],
        ["Data", match.scheduled_on&.strftime("%d/%m/%Y").presence || "________________", "Horário / local", [match.scheduled_time&.strftime("%H:%M"), match.venue_name.presence].compact.join(" · ").presence || "________________"]
      ], column_widths: [85, 300, 85, 300], cell_style: { size: 9, padding: 5, borders: [:bottom], border_color: "BBBBBB" })
      pdf.move_down 5
      pdf.text("#{match.team_a_label}   ×   #{match.team_b_label}", size: 13, style: :bold, align: :center)
    end

    def draw_team_rosters(pdf)
      left = roster_rows(match.team_a)
      right = roster_rows(match.team_b)
      rows = [["Nº", match.team_a_label, "Nº", match.team_b_label]]
      ROSTER_ROWS.times do |index|
        rows << [left[index]&.first.to_s, left[index]&.last.to_s, right[index]&.first.to_s, right[index]&.last.to_s]
      end
      pdf.table(rows, column_widths: [34, 326, 34, 326], header: true,
        cell_style: { size: 8, padding: 3, height: 14, borders: [:bottom], border_color: "C8C8C8" }) do
        row(0).style(background_color: "E8EDF3", font_style: :bold, height: 19)
      end
    end

    def draw_events_area(pdf)
      pdf.table([
        ["Gols / minuto", "Cartões", "Substituições / minuto"],
        ["\n\n", "\n\n", "\n\n"]
      ], column_widths: [360, 180, 360], cell_style: { size: 8, padding: 5, borders: [:bottom, :left, :right], border_color: "A0A0A0" }) do
        row(0).style(background_color: "E8EDF3", font_style: :bold, height: 18)
        row(1).style(height: 34)
      end
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
  end
end
