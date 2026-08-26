require "test_helper"

class PhaseTwoEndpointsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @championship = Championship.create!(
      source_id: "champ-phase-two",
      name: "Campeonato Fase 2",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-phase-two",
      championship: @championship,
      name: "Sub 14"
    )

    @entity = Entity.create!(
      source_id: "entity-phase-two",
      name: "Time Fase 2"
    )

    @team = Team.create!(
      source_id: "team-phase-two",
      entity: @entity,
      category: @category,
      name: "Time Fase 2"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-phase-two",
      team: @team,
      category: @category,
      name: "Atleta Fase 2"
    )

    @match = Match.create!(
      source_id: "match-phase-two",
      championship: @championship,
      category: @category,
      code: "R1",
      phase: "grupos"
    )
  end

  test "creates a match report" do
    post match_match_reports_path(@match), params: {
      match_report: {
        source_id: "report-phase-two",
        status: "enviado"
      }
    }

    assert_response :created
    assert_equal "enviado", JSON.parse(response.body).fetch("status")
  end

  test "creates a suspension" do
    post suspensions_path, params: {
      championship_id: @championship.id,
      suspension: {
        source_id: "susp-phase-two",
        athlete_id: @athlete.id,
        reason: "Cartões acumulados",
        automatic: true,
        matches_count: 1
      }
    }

    assert_response :created
    assert_equal "ativa", JSON.parse(response.body).fetch("status")
  end

  test "creates a round selection with athletes" do
    post round_selections_path, params: {
      championship_id: @championship.id,
      round_selection: {
        source_id: "round-selection-phase-two",
        category_id: @category.id,
        round_number: 1,
        title: "Rodada 1",
        athlete_ids: [@athlete.id]
      }
    }

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "Rodada 1", body.fetch("title")
    assert_equal 1, body.fetch("athletes").size
  end

  test "creates automatic suspension when the third yellow card is recorded" do
    3.times do |index|
      post match_match_events_path(@match), params: {
        match_event: {
          source_id: "yellow-card-#{index}",
          team_id: @team.id,
          athlete_id: @athlete.id,
          kind: "cartao_amarelo"
        }
      }

      assert_response :created
    end

    suspension = Suspension.find_by(championship: @championship, athlete: @athlete)

    assert suspension.automatic?
    assert_equal "Acúmulo de cartões amarelos (3)", suspension.reason
  end

  test "sweeps expired suspensions on index" do
    Suspension.create!(
      source_id: "expired-suspension",
      championship: @championship,
      category: @category,
      team: @team,
      athlete: @athlete,
      reason: "Expirada",
      ends_on: Date.current - 1.day
    )

    get suspensions_path, params: { championship_id: @championship.id }

    assert_response :success
    assert Suspension.find_by(source_id: "expired-suspension").status_cumprida?
  end
end
