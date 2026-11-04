require "test_helper"

class ChampionshipSetupDataTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @championship = Championship.create!(
      source_id: "champ-data-ux-test",
      name: "Campeonato de teste",
      season: 2026
    )
  end

  test "explains optional dates and separates them from optional visual identity" do
    get setup_championship_path(@championship, step: "data")

    assert_response :success
    assert_select "#registration-dates-heading", text: "Período de inscrições"
    assert_select "#championship-dates-heading", text: "Período do campeonato"
    assert_select "input[type='date'][required]", count: 0
    assert_includes response.body, "Todas as datas são opcionais"
    assert_includes response.body, "Identidade visual"
    assert_includes response.body, "Você também pode adicionar o logo depois."
    assert_select "section#championship-visual-identity.bg-base-100", count: 1
    assert_select "details#championship-visual-identity", count: 0
    assert_select 'form[data-controller~="color-preview"]'
    assert_select 'form[enctype="multipart/form-data"]', count: 1
    assert_select 'button[type="submit"][name="step"][value="format"]', text: "Salvar e ir para Formato", count: 1
    assert_not_includes response.body, "Salvar identidade visual"
    assert_select '[data-color-preview-target="primarySwatch"]'
    assert_select '[data-color-preview-target="secondarySwatch"]'
    assert_select "a", text: "Classificação", count: 0
    assert_not_includes response.body, "Padrão importado"
  end

  test "saves calendar and visual identity together before moving to format" do
    patch championship_path(@championship), params: {
      current_step: "data",
      step: "format",
      championship: {
        registration_start: "2026-11-10",
        registration_end: "2026-11-20",
        start_date: "2026-12-01",
        end_date: "2026-12-10",
        notes: "Regulamento unificado",
        primary_color: "#123456",
        secondary_color: "#fedcba"
      }
    }

    assert_redirected_to setup_championship_path(@championship, step: "format")
    @championship.reload
    assert_equal [Date.new(2026, 11, 10), Date.new(2026, 11, 20)], [@championship.registration_start, @championship.registration_end]
    assert_equal [Date.new(2026, 12, 1), Date.new(2026, 12, 10)], [@championship.start_date, @championship.end_date]
    assert_equal "Regulamento unificado", @championship.notes
    assert_equal ["#123456", "#fedcba"], [@championship.primary_color, @championship.secondary_color]
  end
end
