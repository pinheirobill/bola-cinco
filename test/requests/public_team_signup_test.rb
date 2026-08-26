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
  end

  test "creates a public team signup" do
    assert_difference -> { Entity.count }, 1 do
      assert_difference -> { Team.count }, 1 do
        post championship_team_signup_path(@championship), params: {
          entity: {
            source_id: "entity-public-team-signup",
            name: "Escola Pública",
            responsible: "Marcos",
            phone: "(11) 99999-9999",
            email: "escola@example.com",
            city: "São Paulo",
            notes: "Cadastro público"
          },
          team: {
            source_id: "team-public-team-signup",
            category_id: @category.id,
            name: "Time Público",
            short_name: "Público"
          }
        }
      end
    end

    assert_response :redirect
    team = Team.find_by(source_id: "team-public-team-signup")
    assert_equal @category, team.category
    assert_equal "Escola Pública", team.entity.name
  end

  test "shows validation errors when the category is missing" do
    post championship_team_signup_path(@championship), params: {
      entity: {
        source_id: "entity-public-team-signup-invalid",
        name: "Escola Pública",
        responsible: "Marcos"
      },
      team: {
        source_id: "team-public-team-signup-invalid",
        name: "Time Público"
      }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "categoria"
  end
end
