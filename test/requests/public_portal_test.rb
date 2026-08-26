require "test_helper"

class PublicPortalTest < ActionDispatch::IntegrationTest
  setup do
    @draft_championship = Championship.create!(
      source_id: "champ-draft-public",
      name: "Campeonato Rascunho",
      season: 2027
    )

    @championship = Championship.create!(
      source_id: "champ-public-portal",
      name: "Campeonato Portal",
      season: 2026,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-public-portal",
      championship: @championship,
      name: "Sub 18"
    )

    @entity = Entity.create!(
      source_id: "entity-public-portal",
      name: "Escola Portal"
    )

    @team = Team.create!(
      source_id: "team-public-portal",
      entity: @entity,
      category: @category,
      name: "Time Portal"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-public-portal",
      team: @team,
      category: @category,
      name: "Atleta Portal"
    )

    @match = Match.create!(
      source_id: "match-public-portal",
      championship: @championship,
      category: @category,
      code: "J1",
      phase: "grupos",
      status: :finalizado,
      score_a: 3,
      score_b: 2,
      team_a: @team,
      team_b: @team
    )

    StandingRow.create!(
      championship: @championship,
      category: @category,
      team: @team,
      position: 1,
      played: 1,
      wins: 1,
      draws: 0,
      losses: 0,
      goals_for: 3,
      goals_against: 2,
      goal_diff: 1,
      points: 3
    )

    @championship.news_items.create!(
      source_id: "news-public-portal",
      title: "Portal aberto",
      status: :publicada,
      published_at: Time.current
    )

    @championship.partners.create!(
      source_id: "partner-public-portal",
      name: "Parceiro Portal",
      status: :ativo,
      highlight: true
    )

    @championship.round_selections.create!(
      source_id: "round-public-portal",
      title: "Seleção da rodada",
      round_number: 1
    )
  end

  test "shows the public home page and ignores newer drafts" do
    get root_path

    assert_response :success
    assert_includes response.body, "Campeonato Portal"
    refute_includes response.body, "Campeonato Rascunho"
  end

  test "shows a public championship by friendly slug" do
    assert_includes championship_path(@championship), @championship.slug

    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Campeonato Portal"
    assert_includes response.body, "Top atletas"
    assert_includes response.body, "Portal aberto"
  end

  test "scopes public team, athlete and standings pages to the current championship" do
    get team_path(@team)
    assert_response :success
    assert_includes response.body, "Time Portal"

    get athlete_path(@athlete)
    assert_response :success
    assert_includes response.body, "Atleta Portal"

    get standing_rows_path
    assert_response :success
    assert_includes response.body, "Time Portal"
  end
end
