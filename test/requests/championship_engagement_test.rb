require "test_helper"

class ChampionshipEngagementTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @championship = Championship.create!(
      source_id: "champ-engagement",
      name: "Campeonato Engajamento",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-engagement",
      championship: @championship,
      name: "Sub 19"
    )

    @entity = Entity.create!(
      source_id: "entity-engagement",
      name: "Time Engajamento"
    )

    @team = Team.create!(
      source_id: "team-engagement",
      entity: @entity,
      category: @category,
      name: "Time Engajamento"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-engagement",
      team: @team,
      category: @category,
      name: "Atleta Engajamento"
    )

    @match = Match.create!(
      source_id: "match-engagement",
      championship: @championship,
      category: @category,
      code: "J1",
      phase: "grupos",
      status: :finalizado,
      score_a: 2,
      score_b: 1
    )

    MatchEvent.create!(
      source_id: "event-engagement-1",
      match: @match,
      team: @team,
      athlete: @athlete,
      kind: :gol
    )

    @championship.partners.create!(
      source_id: "partner-engagement",
      name: "Parceiro 1",
      highlight: true
    )
  end

  test "returns engagement snapshot" do
    get championship_engagement_path

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal "Campeonato Engajamento", body.fetch("championship").fetch("name")
    assert_equal 1, body.fetch("top_athletes").size
    assert_equal 1, body.fetch("featured_partners").size
  end
end
