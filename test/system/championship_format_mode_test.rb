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
    @category = Category.create!(
      source_id: "category-system-format-#{@suffix}",
      championship: @championship,
      name: "Mirim"
    )

    @championship.update!(
      format: {
        "mode" => "grupos_mata_mata",
        "groupCount" => 1,
        "teamCount" => 9,
        "matchesPerOpponent" => 1
      }
    )
  end

  teardown do
    @championship&.destroy!
    Warden.test_reset!
  end

  test "persists the group-and-knockout mode when selecting the mode card" do
    visit setup_championship_path(@championship, step: "format")

    click_button "Fase de grupos + mata-mata"

    assert_equal "grupos_mata_mata", @championship.reload.format_data["mode"]
  end

  test "persists category-specific formats and cross-group scheduling" do
    visit setup_championship_path(@championship, step: "format")

    select "Pontuação / todos contra todos", from: "championship_format_categoryFormats_#{@category.id}_mode"
    fill_in "championship_format_categoryFormats_#{@category.id}_groupCount", with: 2
    select "Uma chave contra a outra", from: "championship_format_categoryFormats_#{@category.id}_schedule"

    assert_text "Salvo"
    saved_format = @championship.reload.format_data.dig("categoryFormats", @category.id.to_s)
    assert_equal "pontuacao", saved_format["mode"]
    assert_equal "2", saved_format["groupCount"]
    assert_equal "cross_groups", saved_format["schedule"]
  end

  test "shows the expected match count explanation" do
    visit setup_championship_path(@championship, step: "format")

    assert_text "9 equipes em 1 chave com 1 vez por adversário geram 36 jogos."
  end

  test "shows the team match limit field" do
    visit setup_championship_path(@championship, step: "format")

    assert_text "Jogos por equipe"
    assert_text "Ex.: 4 limita cada equipe a quatro jogos na fase classificatória."
  end
end
