require "test_helper"

class RemainingAdminAuthorizationTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:two)

    @championship = Championship.create!(source_id: "remaining-admin-champ", name: "Copa", season: 2026)
    @category = Category.create!(source_id: "remaining-admin-cat", championship: @championship, name: "Sub 14")
    entity = Entity.create!(source_id: "remaining-admin-entity", name: "Entidade")
    @team = Team.create!(source_id: "remaining-admin-team", category: @category, entity: entity, name: "Time")
    athlete = Athlete.create!(source_id: "remaining-admin-athlete", team: @team, category: @category, name: "Atleta")
    @match = Match.create!(source_id: "remaining-admin-match", championship: @championship, category: @category, code: "R1", phase: "grupos")
    @suspension = Suspension.create!(source_id: "remaining-admin-susp", championship: @championship, category: @category,
      team: @team, athlete: athlete, reason: "Disciplina", matches_count: 1)
    @report = MatchReport.create!(source_id: "remaining-admin-report", match: @match, status: :rascunho)
    @venue = Venue.create!(source_id: "remaining-admin-venue", name: "Quadra")
    @referee = Referee.create!(source_id: "remaining-admin-referee", name: "Árbitro")
    @partner = Partner.create!(source_id: "remaining-admin-partner", name: "Parceiro")
  end

  test "team-level user cannot create or mutate championship suspensions" do
    post suspensions_path, params: { championship_id: @championship.id, suspension: { reason: "Nova" } }
    assert_response :forbidden

    patch suspension_path(@suspension), params: { suspension: { reason: "Alterada" } }
    assert_response :forbidden
    assert_equal "Disciplina", @suspension.reload.reason

    delete suspension_path(@suspension)
    assert_response :forbidden
    assert Suspension.exists?(@suspension.id)
  end

  test "team-level user cannot create, approve, update or delete match reports" do
    get match_reports_path(format: :json)
    assert_response :success
    assert_empty JSON.parse(response.body)

    post match_match_reports_path(@match), params: { match_report: { status: "enviado" } }
    assert_response :forbidden

    patch approve_match_report_path(@report)
    assert_response :forbidden

    patch match_report_path(@report), params: { match_report: { status: "aprovado" } }
    assert_response :forbidden
    assert_equal "rascunho", @report.reload.status

    delete match_report_path(@report)
    assert_response :forbidden
    assert MatchReport.exists?(@report.id)
  end

  test "team-level user cannot create or mutate venues, referees or partners" do
    post venues_path, params: { venue: { name: "Outra quadra" } }
    assert_response :forbidden
    patch venue_path(@venue), params: { venue: { name: "Alterada" } }
    assert_response :forbidden

    post referees_path, params: { referee: { name: "Outro árbitro" } }
    assert_response :forbidden
    patch referee_path(@referee), params: { referee: { name: "Alterado" } }
    assert_response :forbidden

    post partners_path, params: { partner: { name: "Outro parceiro" } }
    assert_response :forbidden
    patch partner_path(@partner), params: { partner: { name: "Alterado" } }
    assert_response :forbidden

    assert_equal "Quadra", @venue.reload.name
    assert_equal "Árbitro", @referee.reload.name
    assert_equal "Parceiro", @partner.reload.name
  end
end
