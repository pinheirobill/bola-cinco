require "prawn"

module BolaCinco
  class TrancaSummulaDocument
    PAGE_SIZE = "A4".freeze

    def initialize(partida, filled: false)
      @partida = partida
      @filled = filled
    end

    def self.render_all(partidas)
      Prawn::Document.new(page_size: PAGE_SIZE, margin: 24, page_layout: :landscape) do |pdf|
        partidas.each_with_index do |partida, index|
          pdf.start_new_page if index.positive?
          new(partida).render_page(pdf)
        end
      end.render
    end

    def render
      Prawn::Document.new(page_size: PAGE_SIZE, margin: 24, page_layout: :landscape) do |pdf|
        render_page(pdf)
      end.render
    end

    def render_page(pdf)
      draw_background(pdf)
      draw_header(pdf)
      draw_match_info(pdf)
      draw_score_board(pdf)
      draw_footer(pdf)
    end

    private

    attr_reader :partida, :filled

    def draw_background(pdf)
      pdf.fill_color "FFFFFF"
      pdf.fill_rectangle [0, pdf.cursor + 24], pdf.bounds.width, pdf.bounds.height
    end

    def draw_header(pdf)
      pdf.fill_color "111827"
      pdf.text_box(partida.championship.name, at: [0, pdf.bounds.top - 8], width: pdf.bounds.width, align: :center, size: 16, style: :bold)
      pdf.fill_color "374151"
      pdf.text_box("Súmula da partida", at: [0, pdf.bounds.top - 28], width: pdf.bounds.width, align: :center, size: 9, style: :bold)
    end

    def draw_match_info(pdf)
      left = 24
      top = 520

      box(pdf, [left, top], 220, 52, fill: "FEF3C7", stroke: "D97706")
      pdf.fill_color "111827"
      pdf.text_box("Data: #{formatted_date}   Chave: #{partida.group_key.presence || '-'}", at: [left + 6, top - 18], width: 208, size: 13, style: :bold)
      pdf.text_box("Jogo nº: #{partida.code}", at: [left + 6, top - 36], width: 102, size: 11, style: :bold)
      pdf.text_box("Mesa nº: #{partida.tranca_mesa&.code.presence || partida.code}", at: [left + 114, top - 36], width: 102, size: 11, style: :bold)

      box(pdf, [left + 228, top], 485, 52, fill: "FBBF24", stroke: "D97706")
      pdf.fill_color "111827"
      pdf.text_box("Placar", at: [left + 228, top - 17], width: 485, align: :center, size: 16, style: :bold)

      box(pdf, [left, top - 54], 710, 48, fill: "FEF3C7", stroke: "D97706")
      pdf.fill_color "111827"
      pdf.text_box(partida.dupla_a_nome.presence || "-", at: [left + 10, top - 70], width: 300, size: 12, style: :bold, overflow: :shrink_to_fit)
      pdf.text_box("X", at: [left + 340, top - 70], width: 20, size: 14, style: :bold, align: :center)
      pdf.text_box(partida.dupla_b_nome.presence || "-", at: [left + 370, top - 70], width: 330, size: 12, style: :bold, overflow: :shrink_to_fit)
    end

    def draw_score_board(pdf)
      left = 24
      top = 416
      left_col_width = 170
      middle_width = 370
      right_col_width = 170
      middle_x = left + left_col_width
      right_x = middle_x + middle_width

      box(pdf, [left, top], left_col_width, 248, fill: "FFFFFF")
      box(pdf, [middle_x, top], middle_width, 248, fill: "FFFDF7")
      box(pdf, [right_x, top], right_col_width, 248, fill: "FFFFFF")

      pdf.fill_color "111827"
      pdf.text_box("1ª batida", at: [left + 18, top - 24], width: left_col_width - 36, size: 13, style: :bold)
      pdf.text_box("2ª batida", at: [left + 18, top - 66], width: left_col_width - 36, size: 13, style: :bold)
      pdf.text_box("3ª batida", at: [left + 18, top - 108], width: left_col_width - 36, size: 13, style: :bold)
      pdf.text_box("4ª batida", at: [left + 18, top - 150], width: left_col_width - 36, size: 13, style: :bold)
      pdf.text_box("TOTAL", at: [left + 18, top - 192], width: left_col_width - 36, size: 14, style: :bold)

      4.times do |index|
        y = top - 18 - (index * 42)
        line_box(pdf, [left + 85, y], 68, 24)
        write_box_value(pdf, [left + 85, y], 68, 24, hand_value(index, :a))
      end
      line_box(pdf, [left + 85, top - 186], 68, 24)
      write_box_value(pdf, [left + 85, top - 186], 68, 24, total_score(:a))

      pdf.fill_color "111827"
      pdf.text_box("Data:", at: [middle_x + 24, top - 26], width: 70, size: 14, style: :bold)
      line_box(pdf, [middle_x + 74, top - 20], 150, 22)
      write_inline_value(pdf, [middle_x + 74, top - 20], 150, 22, formatted_date, size: 10) if filled
      pdf.text_box("X", at: [middle_x + 236, top - 26], width: 18, size: 14, style: :bold, align: :center)

      pdf.text_box("TOTAL DE PONTOS", at: [middle_x + 10, top - 68], width: 150, size: 11, style: :bold, overflow: :shrink_to_fit)
      line_box(pdf, [middle_x + 10, top - 76], 170, 24)
      pdf.text_box("x", at: [middle_x + 190, top - 68], width: 14, size: 14, style: :bold, align: :center)
      pdf.text_box("TOTAL DE PONTOS", at: [middle_x + 210, top - 68], width: 150, size: 11, style: :bold, overflow: :shrink_to_fit)
      line_box(pdf, [middle_x + 210, top - 76], 150, 24)
      write_box_value(pdf, [middle_x + 10, top - 76], 170, 24, total_score(:a))
      write_box_value(pdf, [middle_x + 210, top - 76], 150, 24, total_score(:b))

      pdf.text_box("DUPLA VENCEDORA:", at: [middle_x + 10, top - 145], width: 145, size: 11, style: :bold, overflow: :shrink_to_fit)
      line_box(pdf, [middle_x + 150, top - 150], 210, 24)
      write_box_value(pdf, [middle_x + 150, top - 150], 210, 24, winner_name, size: 9)

      pdf.text_box("RODADA: #{round_label}", at: [middle_x + 128, top - 214], width: 140, size: 12, style: :bold, overflow: :shrink_to_fit)

      pdf.text_box("1ª batida", at: [right_x + 15, top - 26], width: 90, size: 13, style: :bold)
      pdf.text_box("2ª batida", at: [right_x + 15, top - 68], width: 90, size: 13, style: :bold)
      pdf.text_box("3ª batida", at: [right_x + 15, top - 110], width: 90, size: 13, style: :bold)
      pdf.text_box("4ª batida", at: [right_x + 15, top - 152], width: 90, size: 13, style: :bold)
      pdf.text_box("TOTAL", at: [right_x + 15, top - 194], width: 90, size: 14, style: :bold)

      4.times do |index|
        y = top - 18 - (index * 42)
        line_box(pdf, [right_x + 104, y], 68, 24)
        write_box_value(pdf, [right_x + 104, y], 68, 24, hand_value(index, :b))
      end
      line_box(pdf, [right_x + 104, top - 186], 68, 24)
      write_box_value(pdf, [right_x + 104, top - 186], 68, 24, total_score(:b))
    end

    def draw_footer(pdf)
      pdf.fill_color "6B7280"
      pdf.text_box("Preencha a folha, fotografe e envie para o sistema conferir antes de salvar.", at: [24, 36], width: pdf.bounds.width - 48, align: :center, size: 8, style: :italic)
    end

    def box(pdf, origin, width, height, fill:, stroke: "000000")
      pdf.fill_color fill
      pdf.stroke_color stroke
      pdf.fill_and_stroke_rectangle origin, width, height
    end

    def line_box(pdf, origin, width, height)
      original_fill = pdf.fill_color
      original_stroke = pdf.stroke_color
      pdf.stroke_color "111827"
      pdf.fill_color "FFFFFF"
      pdf.fill_and_stroke_rectangle origin, width, height
      pdf.fill_color original_fill
      pdf.stroke_color original_stroke
    end

    def formatted_date
      partida.scheduled_on&.strftime("%-d/%-m/%Y") || Date.current.strftime("%-d/%-m/%Y")
    end

    def round_label
      "#{partida.round_number.presence || 1}ª"
    end

    def hand_value(index, side)
      return nil unless filled

      hand = (@hands ||= partida.maos.to_a.sort_by { |mao| [mao.numero, mao.id] })[index]
      return nil if hand.blank?

      side == :a ? hand.pontos_a : hand.pontos_b
    end

    def total_score(side)
      return nil unless filled

      side == :a ? partida.score_a : partida.score_b
    end

    def winner_name
      return nil unless filled

      partida.winner&.name.presence || "Calculado automaticamente"
    end

    def write_box_value(pdf, origin, width, height, value, size: 12)
      return if value.blank?

      pdf.fill_color "111827"
      pdf.text_box(value.to_s, at: [origin[0], origin[1] - 4], width: width, height: height, align: :center, valign: :center, size: size, style: :bold, overflow: :shrink_to_fit, min_font_size: 7)
      pdf.fill_color "111827"
    end

    def write_inline_value(pdf, origin, width, height, value, size: 10)
      return unless filled
      return if value.blank?

      pdf.fill_color "111827"
      pdf.text_box(value.to_s, at: [origin[0] + 8, origin[1] - 2], width: width - 16, height: height - 4, size: size, align: :left, valign: :center, style: :bold)
      pdf.fill_color "111827"
    end
  end
end
