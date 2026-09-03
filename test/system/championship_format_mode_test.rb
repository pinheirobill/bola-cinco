require "application_system_test_case"
require "securerandom"

class ChampionshipFormatModeTest < ApplicationSystemTestCase
  setup do
    @suffix = SecureRandom.hex(4)
    @user = users(:one)
    login_as @user, scope: :user

    @championship = Championship.create!(
      source_id: "champ-system-format-#{@suffix}",
      name: "Campeonato System Format",
      season: 2026
    )
  end

  teardown do
    @championship&.destroy!
    Warden.test_reset!
  end

  test "persists the group-and-knockout mode when selecting the mode card" do
    visit setup_championship_path(@championship, step: "format")

    click_button "Fase de grupos + mata-mata"

    assert_text "Campeonato atualizado."
    assert_equal "grupos_mata_mata", @championship.reload.format_data["mode"]
  end
end
