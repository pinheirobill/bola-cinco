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

  test "hides unused registration controls while retaining their saved values in the form" do
    @championship.update!(rules: @championship.rules_data.deep_merge(
      "registration" => {
        "athlete_actions" => { "allow_register" => true, "allow_edit" => true, "allow_remove" => false },
        "team_signups" => { "enabled" => false },
        "athlete_form" => { "cpf" => "obrigatorio" }
      }
    ))

    get setup_championship_path(@championship, step: "registrations")

    assert_response :success
    [
      "Inscrições de atletas pelos técnicos",
      "Permitir inscrição de atletas",
      "Inscrições de times pelo site do campeonato",
      "Inscrições abertas",
      "Ficha de inscrição de atletas",
      "Permissões do técnico"
    ].each { |label| refute_includes response.body, label }
    assert_includes response.body, "Defina os limites de atletas e membros da comissão técnica."

    hidden_fields = Nokogiri::HTML(response.body).css('input[type="hidden"]').index_by { |field| field["name"] }
    assert_equal "1", hidden_fields.fetch("championship[rules][registration][athlete_actions][allow_register]")["value"]
    assert_equal "1", hidden_fields.fetch("championship[rules][registration][athlete_actions][allow_edit]")["value"]
    assert_equal "0", hidden_fields.fetch("championship[rules][registration][athlete_actions][allow_remove]")["value"]
    assert_equal "0", hidden_fields.fetch("championship[rules][registration][team_signups][enabled]")["value"]
    assert_equal "obrigatorio", hidden_fields.fetch("championship[rules][registration][athlete_form][cpf]")["value"]
  end
end
