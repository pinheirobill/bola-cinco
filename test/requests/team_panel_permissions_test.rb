require "test_helper"

class TeamPanelPermissionsTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @outsider = users(:two)

    @championship = Championship.create!(
      source_id: "champ-team-panel",
      name: "Campeonato Painel",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-team-panel",
      championship: @championship,
      name: "Sub 15"
    )

    @entity = Entity.create!(
      source_id: "entity-team-panel",
      name: "Clube Painel"
    )

    @team = Team.create!(
      source_id: "team-team-panel",
      entity: @entity,
      category: @category,
      name: "Time Painel"
    )

    TeamMembership.create!(
      source_id: "membership-team-panel",
      team: @team,
      user: @admin,
      role: :tecnico
    )
  end

  test "admin sees team panel data" do
    sign_in @admin

    get team_panel_path, params: { team_id: @team.id }

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal "Time Painel", body.fetch("team").fetch("name")
    assert_equal 1, body.fetch("teams").size
    assert_equal "Campeonato Painel", body.fetch("championship").fetch("name")
    assert_equal 18, body.fetch("championship").fetch("max_athletes_per_team")
  end

  test "outsider is forbidden from team panel" do
    sign_in @outsider

    get team_panel_path, params: { team_id: @team.id }

    assert_response :forbidden
  end

  test "outsider is forbidden from team membership management" do
    sign_in @outsider

    post team_team_memberships_path(@team), params: {
      team_membership: {
        source_id: "membership-outsider",
        role: "capitao"
      }
    }

    assert_response :forbidden
  end
end
