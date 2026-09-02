require "test_helper"

class FootballPortalTest < ActionDispatch::IntegrationTest
  setup do
    @championship = Championship.create!(
      source_id: "champ-football-portal",
      name: "Campeonato Futebol",
      season: 2026,
      status: :em_andamento
    )
  end

  test "shows the football portal with its own route" do
    get football_root_path

    assert_response :success
    assert_includes response.body, "Portal de Futebol"
    assert_includes response.body, "Campeonato Futebol"
  end

  test "shows the football login page" do
    get football_login_path

    assert_response :success
    assert_includes response.body, "Entrar no portal futebol"
    assert_includes response.body, 'name="portal"'
    assert_includes response.body, 'value="football"'
  end
end
