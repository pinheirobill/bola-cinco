require "test_helper"

class MatchEventsDashboardTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)

    @championship_a = Championship.create!(
      source_id: "champ-events-a",
      name: "Campeonato Eventos A",
      season: 2026,
      status: :em_andamento
    )

    @championship_b = Championship.create!(
      source_id: "champ-events-b",
      name: "Campeonato Eventos B",
      season: 2027,
      status: :em_andamento
    )

    @category_a = Category.create!(
      source_id: "cat-events-a",
      championship: @championship_a,
      name: "Sub 14"
    )

    @category_b = Category.create!(
      source_id: "cat-events-b",
      championship: @championship_b,
      name: "Sub 16"
    )

    @entity = Entity.create!(
      source_id: "entity-events",
      name: "Escola Eventos"
    )

    @team_a = Team.create!(
      source_id: "team-events-a",
      entity: @entity,
      category: @category_a,
      name: "Equipe Eventos A"
    )

    @team_b = Team.create!(
      source_id: "team-events-b",
      entity: @entity,
      category: @category_b,
      name: "Equipe Eventos B"
    )

    @athlete_a = Athlete.create!(
      source_id: "athlete-events-a",
      team: @team_a,
      category: @category_a,
      name: "Atleta Eventos A",
      shirt_number: "10",
      position: "Pivô",
      status: :validado
    )

    @athlete_b = Athlete.create!(
      source_id: "athlete-events-b",
      team: @team_b,
      category: @category_b,
      name: "Atleta Eventos B",
      shirt_number: "7",
      position: "Ala",
      status: :validado
    )

    @match_a = Match.create!(
      source_id: "match-events-a",
      championship: @championship_a,
      category: @category_a,
      code: "J1",
      phase: "grupos",
      scheduled_on: Date.new(2026, 8, 10),
      team_a: @team_a,
      team_b: @team_b
    )

    @match_b = Match.create!(
      source_id: "match-events-b",
      championship: @championship_b,
      category: @category_b,
      code: "J2",
      phase: "grupos",
      scheduled_on: Date.new(2026, 9, 12),
      team_a: @team_b,
      team_b: @team_a
    )

    MatchEvent.create!(
      source_id: "event-events-a",
      championship: @championship_a,
      match: @match_a,
      team: @team_a,
      athlete: @athlete_a,
      kind: :gol,
      minute: 10,
      period: "1ºT",
      notes: "Gol de abertura"
    )

    MatchEvent.create!(
      source_id: "event-events-b",
      championship: @championship_b,
      match: @match_b,
      team: @team_b,
      athlete: @athlete_b,
      kind: :assistencia,
      minute: 12,
      period: "2ºT",
      notes: "Assistência para o gol decisivo"
    )

    StandingRow.create!(
      championship: @championship_a,
      category: @category_a,
      team: @team_a,
      position: 1,
      played: 1,
      wins: 1,
      draws: 0,
      losses: 0,
      goals_for: 3,
      goals_against: 1,
      goal_diff: 2,
      points: 3
    )

    StandingRow.create!(
      championship: @championship_b,
      category: @category_b,
      team: @team_b,
      position: 1,
      played: 1,
      wins: 1,
      draws: 0,
      losses: 0,
      goals_for: 4,
      goals_against: 2,
      goal_diff: 2,
      points: 3
    )
  end

  test "shows the championship dashboard with rankings and charts" do
    get match_events_path, params: { championship_id: "" }

    assert_response :success
    assert_includes response.body, "Top times"
    assert_includes response.body, "Piores times"
    assert_includes response.body, "Melhores jogadores"
    assert_includes response.body, "Distribuição de eventos"
    assert_includes response.body, "Evolução por mês"
  end

  test "shows the athlete dashboard when an athlete is selected" do
    get match_events_path, params: {
      championship_id: @championship_a.id,
      athlete_id: @athlete_a.id,
      month: "2026-08"
    }

    assert_response :success
    assert_includes response.body, "Jogos jogados"
    assert_includes response.body, "Faltas"
    assert_includes response.body, @athlete_a.name
    assert_includes response.body, "Eventos do atleta"
  end

  test "shows the team dashboard when a team is selected" do
    get match_events_path, params: {
      championship_id: @championship_b.id,
      team_id: @team_b.id
    }

    assert_response :success
    assert_includes response.body, "Jogos jogados"
    assert_includes response.body, "Top atletas"
    assert_includes response.body, @team_b.name
    assert_includes response.body, "Eventos da equipe"
  end

  test "filters data by championship team athlete and month" do
    get match_events_path, params: {
      championship_id: @championship_a.id,
      team_id: @team_a.id,
      athlete_id: @athlete_a.id,
      month: "2026-08"
    }

    assert_response :success
    assert_includes response.body, "Atleta Eventos A"
    assert_includes response.body, "Agosto 2026"
    assert_includes response.body, @athlete_a.name
    refute_includes response.body, @athlete_b.name
    refute_includes response.body, "Setembro 2026"
  end
end
