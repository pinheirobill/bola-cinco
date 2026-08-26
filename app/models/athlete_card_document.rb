class AthleteCardDocument
  CARD_WIDTH = 243
  CARD_HEIGHT = 153

  def initialize(athlete)
    @athlete = athlete
  end

  def render
    Prawn::Document.new(page_size: [CARD_WIDTH, CARD_HEIGHT], margin: 0) do |pdf|
      draw_shell(pdf)
      draw_left_panel(pdf)
      draw_right_panel(pdf)
    end.render
  end

  private

  attr_reader :athlete

  def draw_shell(pdf)
    pdf.fill_color "0F172A"
    pdf.fill_rectangle [0, CARD_HEIGHT], CARD_WIDTH, CARD_HEIGHT
    pdf.fill_color "FFFFFF"
    pdf.fill_rectangle [8, CARD_HEIGHT - 8], CARD_WIDTH - 16, CARD_HEIGHT - 16
  end

  def draw_left_panel(pdf)
    left_x = 8
    left_y = CARD_HEIGHT - 8
    left_width = 108
    left_height = CARD_HEIGHT - 16

    pdf.fill_color "0F172A"
    pdf.fill_rectangle [left_x, left_y], left_width, left_height
    pdf.fill_color "E11D48"
    pdf.fill_rectangle [left_x, left_y], left_width, 3

    pdf.fill_color "FFFFFF"
    pdf.text_box "CARTEIRA DE JOGADOR", at: [left_x + 10, left_y - 14], width: left_width - 20, size: 6, style: :bold, character_spacing: 1.2
    pdf.text_box athlete.category.championship.name, at: [left_x + 10, left_y - 26], width: left_width - 20, size: 10, style: :bold

    pdf.fill_color "FFFFFF"
    pdf.stroke_color "FFFFFF"
    photo_x = left_x + 11
    photo_y = left_y - 42
    pdf.fill_and_stroke_rounded_rectangle [photo_x, photo_y], 42, 42, 10
    pdf.fill_color "E2E8F0"
    pdf.text_box athlete.initials, at: [photo_x + 3, photo_y - 25], width: 36, size: 13, style: :bold, align: :center

    pdf.fill_color "FFFFFF"
    pdf.text_box athlete.name, at: [left_x + 10, left_y - 95], width: left_width - 20, size: 16, style: :bold, overflow: :shrink_to_fit, align: :center
    pdf.fill_color "CBD5E1"
    pdf.text_box "#{athlete.team.name} · #{athlete.category.name}", at: [left_x + 10, left_y - 112], width: left_width - 20, size: 7, align: :center

    pill_y = left_y - 126
    pill(pdf, "Nº #{athlete.shirt_number.presence || "-"}", left_x + 11, pill_y, 38)
    pill(pdf, athlete.position.presence || "Sem posição", left_x + 54, pill_y, 44)

    pdf.fill_color "FFFFFF"
    pdf.text_box "J #{performance[:matches_played]}  G #{performance[:goals]}  A #{performance[:assists]}  C #{performance[:yellow_cards] + performance[:red_cards]}", at: [left_x + 8, 18], width: left_width - 16, size: 7, style: :bold, align: :center
  end

  def draw_right_panel(pdf)
    right_x = 116
    right_y = CARD_HEIGHT - 8
    right_width = CARD_WIDTH - 124

    pdf.fill_color "FFFFFF"
    pdf.fill_rectangle [right_x, right_y], right_width, CARD_HEIGHT - 16

    pdf.fill_color "0F172A"
    pdf.text_box "DADOS DO DOCUMENTO", at: [right_x + 8, right_y - 14], width: right_width - 16, size: 6, style: :bold, character_spacing: 1.0
    pdf.text_box "Credencial oficial", at: [right_x + 8, right_y - 25], width: right_width - 16, size: 12, style: :bold

    field(pdf, "Data de nascimento", athlete.birth_date&.strftime("%d/%m/%Y") || "-", right_x + 8, right_y - 42, right_width - 16, 18)
    field(pdf, "Inscrição", athlete.registration_label.strftime("%d/%m/%Y %H:%M"), right_x + 8, right_y - 59, right_width - 16, 18)
    field(pdf, "CPF", athlete.cpf.presence || athlete.document.presence || "-", right_x + 8, right_y - 76, (right_width - 20) / 2, 18)
    field(pdf, "RG", athlete.rg.presence || "-", right_x + 8 + (right_width - 20) / 2 + 4, right_y - 76, (right_width - 20) / 2, 18)
    field(pdf, "Vínculo", athlete.team.name, right_x + 8, right_y - 93, right_width - 16, 18)
    field(pdf, "Categoria", athlete.category.name, right_x + 8, right_y - 110, right_width - 16, 18)

    pdf.fill_color "334155"
    pdf.text_box "Performance resumida", at: [right_x + 8, 28], width: right_width - 16, size: 7, style: :bold
    pdf.fill_color "0F172A"
    pdf.text_box "Jogos #{performance[:matches_played]} | Gols #{performance[:goals]} | Assist. #{performance[:assists]} | Cartões #{performance[:yellow_cards] + performance[:red_cards]} | Suspensões #{performance[:active_suspensions]}", at: [right_x + 8, 18], width: right_width - 16, size: 7, style: :bold, overflow: :shrink_to_fit
  end

  def pill(pdf, text, x, y, width)
    pdf.fill_color "FFFFFF"
    pdf.stroke_color "334155"
    pdf.fill_and_stroke_rounded_rectangle [x, y], width, 12, 6
    pdf.fill_color "FFFFFF"
    pdf.text_box text, at: [x + 2, y - 8], width: width - 4, size: 5.5, style: :bold, align: :center, overflow: :shrink_to_fit
  end

  def field(pdf, label, value, x, y, width, height)
    pdf.stroke_color "CBD5E1"
    pdf.fill_color "FFFFFF"
    pdf.fill_and_stroke_rounded_rectangle [x, y], width, height, 5
    pdf.fill_color "64748B"
    pdf.text_box label, at: [x + 4, y - 3], width: width - 8, size: 5.5, style: :bold
    pdf.fill_color "0F172A"
    pdf.text_box value, at: [x + 4, y - 11], width: width - 8, size: 7.5, style: :bold, overflow: :shrink_to_fit
  end

  def performance
    athlete.performance_summary
  end
end
