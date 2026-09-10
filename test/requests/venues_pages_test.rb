require "test_helper"

class VenuesPagesTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @championship = Championship.create!(
      source_id: "champ-venues-pages",
      name: "Campeonato Locais",
      season: 2026
    )
  end

  test "shows the venues index with modal trigger instead of inline form" do
    get venues_path

    assert_response :success
    assert_includes response.body, "venue-modal"
    assert_includes response.body, "Novo local"
    refute_includes response.body, "id=\"novo-local\""
  end

  test "redirects when there is no championship to scope venues" do
    @championship.destroy!

    get venues_path

    assert_redirected_to championships_path
    assert_equal "Crie ou selecione um campeonato antes de cadastrar locais.", flash[:alert]
  end

  test "shows the venue dashboard with schedule and charts" do
    category = Category.create!(
      source_id: "cat-venues-pages",
      championship: @championship,
      name: "Sub 17"
    )

    entity_a = Entity.create!(
      source_id: "entity-venues-pages-a",
      name: "Equipe A"
    )

    entity_b = Entity.create!(
      source_id: "entity-venues-pages-b",
      name: "Equipe B"
    )

    team_a = Team.create!(
      source_id: "team-venues-pages-a",
      entity: entity_a,
      category: category,
      name: "Equipe A"
    )

    team_b = Team.create!(
      source_id: "team-venues-pages-b",
      entity: entity_b,
      category: category,
      name: "Equipe B"
    )

    venue = Venue.create!(
      source_id: "venue-venues-pages",
      championship: @championship,
      name: "Ginásio Central",
      city: "São Paulo",
      status: :ativo
    )

    Match.create!(
      source_id: "match-venues-pages-1",
      championship: @championship,
      category: category,
      venue: venue,
      team_a: team_a,
      team_b: team_b,
      code: "J1",
      phase: "grupos",
      status: :finalizado,
      scheduled_on: Date.new(2026, 8, 20),
      scheduled_time: "09:00",
      score_a: 4,
      score_b: 2
    )

    Match.create!(
      source_id: "match-venues-pages-2",
      championship: @championship,
      category: category,
      venue: venue,
      team_a: team_b,
      team_b: team_a,
      code: "J2",
      phase: "grupos",
      status: :agendado,
      scheduled_on: Date.new(2026, 8, 29),
      scheduled_time: "10:30"
    )

    get venue_path(venue)

    assert_response :success
    assert_includes response.body, "Agenda dos jogos"
    assert_includes response.body, "Gols por jogo"
    assert_includes response.body, "Jogos por mês"
    assert_includes response.body, "Distribuição por status"
    assert_includes response.body, "Ginásio Central"
    assert_includes response.body, "J1"
    assert_includes response.body, "4 x 2"
    assert_includes response.body, "20/08/2026"
  end
end
