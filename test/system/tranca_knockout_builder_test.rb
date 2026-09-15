require "application_system_test_case"
require "securerandom"

class TrancaKnockoutBuilderTest < ApplicationSystemTestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-system-knockout-builder-#{SecureRandom.hex(4)}",
      name: "Torneio de Tranca",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )

    login_as users(:one), scope: :user
  end

  teardown do
    @championship&.destroy!
  end

  test "advances from knockout type to manual bracket selection" do
    visit rodadas_championship_path(@championship)

    click_button "Configurar chave eliminatória"
    assert_selector "#tranca-knockout-config-modal[open]"

    select "Quartas / semi / final", from: "Tipo de mata-mata"
    click_button "Continuar"

    assert_text "Etapa 2"
    assert_text "0/8 duplas selecionadas"
    assert_no_text "Próxima etapa"
  end
end
