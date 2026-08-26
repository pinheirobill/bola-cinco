require "test_helper"

class RegistrationRulesEnforcementTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @manager = users(:two)

    @championship = Championship.create!(
      source_id: "champ-registration-rules",
      name: "Campeonato Regras",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-registration-rules",
      championship: @championship,
      name: "Sub 18"
    )

    @entity = Entity.create!(
      source_id: "entity-registration-rules",
      name: "Clube Regras"
    )

    @team = Team.create!(
      source_id: "team-registration-rules",
      entity: @entity,
      category: @category,
      name: "Time Regras"
    )

    TeamMembership.create!(
      source_id: "membership-registration-rules",
      team: @team,
      user: @manager,
      role: :tecnico
    )
  end

  test "forbids team creation when public signups are closed" do
    sign_in @manager
    @championship.update!(
      rules: {
        "registration" => {
          "team_signups" => {
            "enabled" => false
          }
        }
      }
    )

    post teams_path, params: {
      team: {
        source_id: "team-closed",
        entity_id: @entity.id,
        category_id: @category.id,
        name: "Time Fechado"
      }
    }

    assert_response :forbidden
  end

  test "forbids athlete creation when registration is closed" do
    sign_in @manager
    @championship.update!(
      rules: {
        "registration" => {
          "athlete_actions" => {
            "allow_register" => false
          }
        }
      }
    )

    post athletes_path, params: {
      athlete: {
        source_id: "athlete-closed",
        team_id: @team.id,
        category_id: @category.id,
        name: "Atleta Fechado"
      }
    }

    assert_response :forbidden
  end

  test "forbids athlete creation when the team limit is reached" do
    sign_in @manager
    @championship.update!(
      rules: {
        "registration" => {
          "max_athletes_per_team" => 1
        }
      }
    )

    Athlete.create!(
      source_id: "athlete-existing-limit",
      team: @team,
      category: @category,
      name: "Atleta Existente"
    )

    post athletes_path, params: {
      athlete: {
        source_id: "athlete-over-limit",
        team_id: @team.id,
        category_id: @category.id,
        name: "Atleta Excedente"
      }
    }

    assert_response :forbidden
  end

  test "forbids team membership creation when the staff limit is reached" do
    sign_in @manager
    @championship.update!(
      rules: {
        "registration" => {
          "max_staff_members_per_team" => 1
        }
      }
    )

    other_user = User.create!(
      email: "outro.gestor@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :tecnico_do_time
    )

    post team_team_memberships_path(@team), params: {
      team_membership: {
        source_id: "membership-over-limit",
        user_id: other_user.id,
        role: "capitao"
      }
    }

    assert_response :forbidden
  end
end
