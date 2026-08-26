require "test_helper"

class ChampionshipRegistrationSettingsTest < ActiveSupport::TestCase
  test "defaults the registration settings" do
    championship = Championship.create!(
      source_id: "champ-registration-defaults",
      name: "Campeonato Inscrições",
      season: 2026
    )

    assert_equal 18, championship.max_athletes_per_team
    assert_equal 5, championship.max_staff_members_per_team
    assert championship.team_signup_enabled?
    assert championship.athlete_action_enabled?("allow_register")
    assert championship.athlete_action_enabled?("allow_edit")
    refute championship.athlete_action_enabled?("allow_remove")
    assert_equal "obrigatorio", championship.athlete_form_requirement("cpf")
    assert_equal "cpf", championship.printed_summary_field
  end
end
