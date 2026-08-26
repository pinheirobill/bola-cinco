require "test_helper"

class PublicTeamSignupTest < ActionDispatch::IntegrationTest
  setup do
    @championship = Championship.create!(
      source_id: "champ-public-team-signup",
      name: "Campeonato Inscrição Time",
      season: 2026,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-public-team-signup",
      championship: @championship,
      name: "Sub 16"
    )

    other_championship = Championship.create!(
      source_id: "champ-public-team-signup-other",
      name: "Campeonato Base",
      season: 2025,
      status: :em_andamento
    )

    @existing_category = Category.create!(
      source_id: "cat-public-team-signup-other",
      championship: other_championship,
      name: "Sub 14"
    )

    @entity = Entity.create!(
      source_id: "entity-public-team-signup",
      name: "Escola Pública"
    )

    @team = Team.create!(
      source_id: "team-public-team-signup",
      entity: @entity,
      category: @existing_category,
      name: "Time Público",
      short_name: "Público"
    )
  end

  test "selects an existing team without creating new records" do
    assert_no_difference -> { Entity.count } do
      assert_no_difference -> { Team.count } do
        post championship_team_signup_path(@championship), params: {
          team_signup: {
            team_id: @team.id,
            category_id: @category.id
          }
        }
      end
    end

    assert_response :redirect
    assert_equal @category, @team.reload.category
  end

  test "shows validation errors when the team is missing" do
    post championship_team_signup_path(@championship), params: {
      team_signup: {
        category_id: @category.id
      }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "time"
  end
end
