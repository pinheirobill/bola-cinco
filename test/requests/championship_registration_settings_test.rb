require "test_helper"

class ChampionshipRegistrationSettingsRequestTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    sign_in @admin

    @championship = Championship.create!(
      source_id: "champ-registration-request",
      name: "Campeonato Configuração",
      season: 2026
    )
  end

  test "updates registration settings from setup" do
    patch championship_path(@championship), params: {
      step: "registrations",
      championship: {
        rules: {
          registration: {
            max_athletes_per_team: 22,
            max_staff_members_per_team: 6,
            athlete_actions: {
              allow_register: "1",
              allow_edit: "1",
              allow_remove: "1"
            },
            team_signups: {
              enabled: "1"
            },
            athlete_form: {
              cpf: "obrigatorio",
              rg: "pede",
              data_nascimento: "obrigatorio"
            },
            printed_summary_field: "rg"
          }
        }
      }
    }

    assert_response :redirect
    assert_equal 22, @championship.reload.max_athletes_per_team
    assert_equal 6, @championship.max_staff_members_per_team
    assert @championship.team_signup_enabled?
    assert @championship.athlete_action_enabled?("allow_remove")
    assert_equal "rg", @championship.printed_summary_field
    assert_equal "pede", @championship.athlete_form_requirement("rg")
  end

  test "allows disabling registration toggles from setup" do
    patch championship_path(@championship), params: {
      step: "registrations",
      championship: {
        rules: {
          registration: {
            athlete_actions: {
              allow_register: "0",
              allow_edit: "0",
              allow_remove: "0"
            },
            team_signups: {
              enabled: "0"
            }
          }
        }
      }
    }

    assert_response :redirect
    assert_not @championship.reload.team_signup_enabled?
    refute @championship.athlete_action_enabled?("allow_register")
    refute @championship.athlete_action_enabled?("allow_edit")
    refute @championship.athlete_action_enabled?("allow_remove")
  end
end
