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
      pdf.move_down 5
      pdf.text("Placar: #{match.score_a.presence || "___"} × #{match.score_b.presence || "___"}     Árbitro: #{match.match_report&.referee&.name.presence || "________________________________"}", size: 9)
      draw_own_goal_fields(pdf)
      pdf.move_down 9
      draw_signatures(pdf)
    end

    private

    attr_reader :match

    def draw_match_details(pdf)
      rows = [
        ["Código", match.code, "Categoria", match.category&.name.to_s],
        ["Fase / rodada", [match.phase.to_s.humanize, ("Rodada #{match.round_number}" if match.round_number.present?)].compact.join(" · "), "Grupo", match.group_key.to_s],
        ["Data", match.scheduled_on&.strftime("%d/%m/%Y").presence || "________________", "Horário / local", [formatted_scheduled_time, match.venue_name.presence].compact.join(" · ").presence || "________________"]
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

    def formatted_scheduled_time
      raw = match.scheduled_time.to_s.strip
      return if raw.blank?

      parsed = raw.match(/\A(?<hour>\d{1,2})[Hh:](?<minute>\d{2})(?::\d{2})?\z/)
      return raw unless parsed

      format("%02d:%02d", parsed[:hour].to_i, parsed[:minute].to_i)
    end

    def draw_team_rosters(pdf)
      left = roster_rows(match.team_a)
      right = roster_rows(match.team_b)
      panel_width = (pdf.bounds.width - 12) / 2.0
      columns = [[22, 94, 24], *Array.new(9) { [18] }, [27, 27]].flatten
      columns = columns.map { |width| width * panel_width / columns.sum }
      row_height = 13
      pdf.text_box(match.team_a_label, at: [0, pdf.cursor], width: panel_width, height: 13,
        size: 8, style: :bold, align: :center, overflow: :shrink_to_fit)
      pdf.text_box(match.team_b_label, at: [panel_width + 12, pdf.cursor], width: panel_width, height: 13,
        size: 8, style: :bold, align: :center, overflow: :shrink_to_fit)
      pdf.move_down 14
      headers = ["Nº", "Atleta", "GOL", *1.upto(9).map { |number| "#{number}º" }, "AMAR", "VERM"]
      header_values = headers + [""] + headers
      header_widths = columns + [12] + columns
      draw_grid_row(pdf, header_values, header_widths, row_height + 2, header: true, font_size: 6)
      ROSTER_ROWS.times do |index|
        left_row = left[index] ? athlete_cells(match.team_a, left[index]) : Array.new(headers.size, "")
        right_row = right[index] ? athlete_cells(match.team_b, right[index]) : Array.new(headers.size, "")
        draw_grid_row(pdf, left_row + [""] + right_row, header_widths, row_height, font_size: 6)
      end
    end

    def athlete_cells(team, athlete)
      events = match.match_events.select { |event| event.team_id == team&.id && event.athlete_id == athlete.id }
      goals = events.select(&:kind_gol?)
      indexed_goals = goals.sort_by do |event|
        sheet_index = event.source_data["event_sheet_index"].to_i if event.source_data.key?("event_sheet_index")
        [sheet_index.present? ? 0 : 1, sheet_index || event.minute.to_i, event.id.to_i]
      end
      goal_minutes = Array.new(9, "")
      indexed_goals.first(9).each_with_index do |event, index|
        goal_minutes[index] = event.minute.present? ? "#{event.minute}'" : ""
      end
      legacy_goal_count = match.scorers.to_h.fetch(athlete.source_id.to_s, 0).to_i

      [athlete.shirt_number.to_s, athlete.name.to_s, [goals.size, legacy_goal_count].max.to_s, *goal_minutes,
        events.count(&:kind_cartao_amarelo?).to_s, events.count(&:kind_cartao_vermelho?).to_s]
    end

    def draw_signatures(pdf)
      pdf.text("\n______________________________________________                               ______________________________________________", size: 9, align: :center)
      pdf.text("Assinatura da arbitragem                                                     Responsável pela mesa", size: 8, align: :center)
    end

    def draw_own_goal_fields(pdf)
      pdf.move_down 4
      pdf.text("GOL CONTRA - marque a equipe que recebeu o gol; não marque um atleta", size: 8, style: :bold)
      [[match.team_a, "EQUIPE A"], [match.team_b, "EQUIPE B"]].each do |team, side_label|
        next unless team

        events = match.own_goal_events_for(team)
        checked_yes = events.any?
        checked_no = !checked_yes
        minutes = events.filter_map { |event| event.minute&.to_s.presence }.join(", ")
        minutes = "________________" if minutes.blank?
        label = "#{side_label} - #{team.name}: GOL CONTRA? [#{checked_yes ? 'X' : ' '}] SIM [#{checked_no ? 'X' : ' '}] NÃO | MINUTOS: #{minutes}"
        pdf.text_box(label, at: [0, pdf.cursor], width: pdf.bounds.width, height: 13,
          size: 7, overflow: :shrink_to_fit, min_font_size: 6)
        pdf.move_down 13
      end
    end

    def roster_rows(team)
      return [] unless team

      participants = match.match_participations.filter_map do |participation|
        participation.athlete if participation.team_id == team.id
      end
      event_athletes = match.match_events.filter_map do |event|
        event.athlete if event.team_id == team.id
      end
      (team.athletes.to_a + participants + event_athletes).uniq(&:id)
        .sort_by { |athlete| [athlete.shirt_number.to_i.zero? ? Float::INFINITY : athlete.shirt_number.to_i, athlete.name.to_s.downcase] }
        .first(ROSTER_ROWS)
    end

    def draw_grid_row(pdf, values, widths, height, header: false, font_size: 8)
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
          size: font_size, style: header ? :bold : :normal, valign: :center,
          overflow: :shrink_to_fit, min_font_size: 6)
        x += width
      end
      pdf.move_down height
    end
  end
end
