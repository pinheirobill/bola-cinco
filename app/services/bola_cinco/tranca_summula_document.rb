require "prawn"

module BolaCinco
  class TrancaSummulaDocument
    include ChampionshipLogoPdf

    PAGE_SIZE = "A4".freeze
    HAND_COUNT = 5
    PAGE_MARGIN = 14

    COLORS = {
      amber: "FDBD0B", amber_dark: "9A5A0A", cream: "F8EFD9", team: "E2CCA0",
      green: "2F7134", green_light: "D9F0D5", yellow_light: "FFE39A",
      total: "FFC65C", red: "B91C1C", gray: "9CA3AF", ink: "1F2937",
      border: "5B5143", white: "FFFFFF"
    }.freeze

    def initialize(partida, filled: false)
      @partida = partida
      @filled = filled
    end

    def self.render_all(partidas)
      Prawn::Document.new(page_size: PAGE_SIZE, margin: PAGE_MARGIN, page_layout: :landscape) do |pdf|
        partidas.each_with_index do |partida, index|
          pdf.start_new_page if index.positive?
          new(partida).render_page(pdf)
        end
      end.render
    end

    def render
      Prawn::Document.new(page_size: PAGE_SIZE, margin: PAGE_MARGIN, page_layout: :landscape) do |pdf|
        render_page(pdf)
      end.render
    end

    def render_page(pdf)
      draw_background(pdf)
      draw_header(pdf)
      draw_match_info(pdf)
      draw_team_cards(pdf)
      draw_score_tables(pdf)
      draw_result(pdf)
      draw_winner(pdf)
    end

    private

    attr_reader :partida, :filled

    def draw_background(pdf)
      pdf.fill_color COLORS[:white]
      pdf.fill_rectangle [0, pdf.bounds.top], pdf.bounds.width, pdf.bounds.height
    end

    def draw_header(pdf)
      top = pdf.bounds.top
      rounded_box(pdf, [0, top], pdf.bounds.width, 34, fill: COLORS[:amber], stroke: COLORS[:amber])
      pdf.fill_color COLORS[:ink]
      pdf.text_box(partida.championship.name, at: [12, top - 7], width: pdf.bounds.width - 24,
        height: 22, align: :center, valign: :center, size: 18, style: :bold,
        overflow: :shrink_to_fit, min_font_size: 12)
    end

    def draw_match_info(pdf)
      top = pdf.bounds.top - 42
      rounded_box(pdf, [0, top], pdf.bounds.width, 42, fill: COLORS[:cream], stroke: COLORS[:border])
      info_item(pdf, "Data:", formatted_date, 20, top - 9, 190)
      info_item(pdf, "Chave:", group_label(partida.group_key), 245, top - 9, 110)
      info_item(pdf, "Jogo:", partida.game_number_label, 370, top - 9, 105)
      info_item(pdf, "ID:", partida.summula_identifier, 505, top - 9, 120)
      info_item(pdf, "Rodada:", round_label, 20, top - 25, 180)
    end

    def draw_team_cards(pdf)
      top = pdf.bounds.top - 92
      gap = 18
      card_width = (pdf.bounds.width - gap) / 2.0
      draw_team_card(pdf, side: :a, title: "DUPLA 1", left: 0, top: top, width: card_width)
      draw_team_card(pdf, side: :b, title: "DUPLA 2", left: card_width + gap, top: top, width: card_width)
    end

    def draw_team_card(pdf, side:, title:, left:, top:, width:)
      rounded_box(pdf, [left, top], width, 54, fill: COLORS[:team], stroke: "9B865F")
      pdf.fill_color COLORS[:ink]
      pdf.text_box(title, at: [left + 8, top - 7], width: width - 16, height: 15,
        align: :center, size: 13, style: :bold)
      pdf.text_box(team_members(side).join("\n"), at: [left + 10, top - 22], width: width - 20,
        height: 29, align: :center, valign: :center, size: 10, leading: 1,
        overflow: :shrink_to_fit, min_font_size: 7)
    end

    def draw_score_tables(pdf)
      label_top = pdf.bounds.top - 153
      gap = 58
      table_width = (pdf.bounds.width - gap) / 2.0
      right_x = table_width + gap
      draw_pair_label(pdf, side: :a, number: 1, left: 0, top: label_top, width: table_width)
      draw_pair_label(pdf, side: :b, number: 2, left: right_x, top: label_top, width: table_width)
      draw_score_table(pdf, side: :a, left: 0, top: label_top - 24, width: table_width)
      draw_score_table(pdf, side: :b, left: right_x, top: label_top - 24, width: table_width)
    end

    def draw_pair_label(pdf, side:, number:, left:, top:, width:)
      pdf.fill_color COLORS[:ink]
      pdf.text_box("Dupla #{number} - #{team_short_name(side)}", at: [left, top], width: width,
        height: 18, align: :center, valign: :center, size: 12, style: :bold,
        overflow: :shrink_to_fit, min_font_size: 8)
    end

    def draw_score_table(pdf, side:, left:, top:, width:)
      header_height = 27
      row_height = 27
      total_height = 30
      columns = score_columns(width)
      draw_table_row(pdf, left: left, top: top, height: header_height, columns: columns, cells: [
        ["BATIDA", COLORS[:cream], COLORS[:ink]],
        ["PONTOS", COLORS[:green], COLORS[:white]],
        ["", COLORS[:cream], COLORS[:ink]],
        ["SUB TOTAL", COLORS[:amber_dark], COLORS[:white]]
      ], font_size: 10)

      HAND_COUNT.times do |index|
        row_top = top - header_height - (index * row_height)
        draw_table_row(pdf, left: left, top: row_top, height: row_height, columns: columns, cells: [
          [ordinal(index + 1), COLORS[:green_light], COLORS[:ink]],
          [hand_value(index, side), COLORS[:green_light], COLORS[:ink]],
          ["=>", COLORS[:green_light], "5B6B62"],
          [subtotal_value(index, side), COLORS[:yellow_light], COLORS[:ink]]
        ], font_size: 10)
      end

      total_top = top - header_height - (HAND_COUNT * row_height)
      label_width = columns[0] + columns[1]
      draw_cell(pdf, left: left, top: total_top, width: label_width, height: total_height,
        value: "TOTAL DE PONTOS", fill: COLORS[:total], text_color: COLORS[:ink], font_size: 10)
      draw_cell(pdf, left: left + label_width, top: total_top, width: columns[2], height: total_height,
        value: "", fill: COLORS[:total], text_color: COLORS[:ink], font_size: 10)
      draw_cell(pdf, left: left + label_width + columns[2], top: total_top, width: columns[3], height: total_height,
        value: total_score(side), fill: COLORS[:total], text_color: COLORS[:ink], font_size: 13)
    end

    def draw_result(pdf)
      top = 174
      rounded_box(pdf, [0, top], pdf.bounds.width, 66, fill: COLORS[:cream], stroke: "9B865F")
      pdf.fill_color COLORS[:ink]
      pdf.text_box("RESULTADO FINAL", at: [0, top - 7], width: pdf.bounds.width,
        height: 18, align: :center, size: 14, style: :bold)

      score_width = 180
      gap = 80
      left = (pdf.bounds.width - (score_width * 2) - gap) / 2.0
      score_top = top - 29
      left_fill = winner_side == :a ? COLORS[:red] : COLORS[:gray]
      right_fill = winner_side == :b ? COLORS[:red] : COLORS[:gray]
      rounded_box(pdf, [left, score_top], score_width, 30, fill: left_fill, stroke: left_fill)
      rounded_box(pdf, [left + score_width + gap, score_top], score_width, 30, fill: right_fill, stroke: right_fill)
      write_centered(pdf, total_score(:a), left, score_top, score_width, 30, size: 19, color: COLORS[:white])
      write_centered(pdf, total_score(:b), left + score_width + gap, score_top, score_width, 30, size: 19, color: COLORS[:white])
      write_centered(pdf, "X", left + score_width, score_top, gap, 30, size: 20, color: COLORS[:ink])
    end

    def draw_winner(pdf)
      top = 96
      rounded_box(pdf, [0, top], pdf.bounds.width, 44, fill: COLORS[:amber], stroke: "9B865F")
      pdf.fill_color "7F1D1D"
      pdf.text_box("DUPLA VENCEDORA:", at: [46, top - 8], width: 230, height: 18, size: 13, style: :bold)
      pdf.text_box(winner_name.to_s, at: [300, top - 8], width: pdf.bounds.width - 340,
        height: 18, size: 13, style: :bold, align: :left, overflow: :shrink_to_fit, min_font_size: 8)
      pdf.fill_color "9A7B2E"
      pdf.text_box("Preencha a folha, fotografe e envie para o sistema. Confira antes de salvar.",
        at: [22, top - 28], width: pdf.bounds.width - 44, height: 11, align: :left, size: 7, style: :italic)
    end

    def draw_table_row(pdf, left:, top:, height:, columns:, cells:, font_size:)
      cursor = left
      cells.each_with_index do |(value, fill, text_color), index|
        draw_cell(pdf, left: cursor, top: top, width: columns[index], height: height,
          value: value, fill: fill, text_color: text_color, font_size: font_size)
        cursor += columns[index]
      end
    end

    def draw_cell(pdf, left:, top:, width:, height:, value:, fill:, text_color:, font_size:)
      box(pdf, [left, top], width, height, fill: fill, stroke: COLORS[:border])
      write_centered(pdf, value, left, top, width, height, size: font_size, color: text_color)
    end

    def write_centered(pdf, value, left, top, width, height, size:, color:)
      return if value.nil? || value.to_s.blank?

      pdf.fill_color color
      pdf.text_box(formatted_score(value), at: [left + 3, top - 3], width: width - 6,
        height: height - 6, align: :center, valign: :center, size: size, style: :bold,
        overflow: :shrink_to_fit, min_font_size: 7)
    end

    def info_item(pdf, label, value, left, top, width)
      pdf.fill_color COLORS[:ink]
      pdf.text_box(label, at: [left, top], width: 58, height: 14, size: 10, style: :bold)
      pdf.text_box(value.to_s, at: [left + 52, top], width: width - 52, height: 14,
        size: 10, overflow: :shrink_to_fit, min_font_size: 7)
    end

    def box(pdf, origin, width, height, fill:, stroke: COLORS[:border])
      pdf.fill_color fill
      pdf.stroke_color stroke
      pdf.line_width 0.9
      pdf.fill_and_stroke_rectangle origin, width, height
    end

    def rounded_box(pdf, origin, width, height, fill:, stroke: COLORS[:border], radius: 5)
      pdf.fill_color fill
      pdf.stroke_color stroke
      pdf.line_width 0.9
      pdf.rounded_rectangle(origin, width, height, radius)
      pdf.fill_and_stroke
    end

    def score_columns(width)
      [64.0, 106.0, 42.0, width - 212.0]
    end

    def hands
      @hands ||= partida.maos.to_a.sort_by { |mao| [mao.numero, mao.id] }
    end

    def hand_value(index, side)
      return nil unless filled

      hand = hands[index]
      return nil if hand.blank?

      side == :a ? hand.pontos_a : hand.pontos_b
    end

    def subtotal_value(index, side)
      return nil unless filled
      return nil if hands[index].blank?

      hands.first(index + 1).sum { |hand| side == :a ? hand.pontos_a.to_i : hand.pontos_b.to_i }
    end

    def total_score(side)
      return nil unless filled

      side == :a ? partida.score_a : partida.score_b
    end

    def team(side)
      side == :a ? partida.team_a : partida.team_b
    end

    def team_members(side)
      dupla = team(side)
      names = dupla&.integrante_names.to_a.compact_blank
      names.presence || [dupla&.name.presence || "-"]
    end

    def team_short_name(side)
      team(side)&.name.presence || "-"
    end

    def winner_name
      return nil unless filled

      partida.winner&.name.presence || team(winner_side)&.name.presence || "Empate"
    end

    def winner_side
      return @winner_side if defined?(@winner_side)
      return @winner_side = nil unless filled

      @winner_side = if partida.winner_id.present?
        partida.winner_id == team(:a)&.id ? :a : :b
      elsif total_score(:a).to_i == total_score(:b).to_i
        nil
      elsif total_score(:a).to_i > total_score(:b).to_i
        :a
      else
        :b
      end
    end

    def formatted_score(value)
      return value.to_s unless value.is_a?(Numeric) || value.to_s.match?(/\A-?\d+\z/)

      value.to_i.to_s.reverse.scan(/.{1,3}/).join(".").reverse
    end

    def formatted_date
      partida.scheduled_on&.strftime("%d/%m/%Y") || Date.current.strftime("%d/%m/%Y")
    end

    def round_label
      "#{partida.round_number.presence || 1}ª"
    end

    def ordinal(number)
      "#{number}ª"
    end

    def group_label(value)
      text = value.to_s.squish
      text = text.sub(/\ACHAVE\s+/i, "").squish
      return "-" if text.blank?
      return alphabet_label(text.to_i) if text.match?(/\A\d+\z/)

      text.upcase
    end

    def alphabet_label(index)
      number = index.to_i
      return "A" if number <= 1

      letters = +""
      while number.positive?
        number, remainder = (number - 1).divmod(26)
        letters.prepend(("A".ord + remainder).chr)
      end
      letters
    end
  end
end
