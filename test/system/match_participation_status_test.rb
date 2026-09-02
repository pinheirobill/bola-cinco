require "application_system_test_case"
require "securerandom"

class MatchParticipationStatusTest < ApplicationSystemTestCase
  setup do
    @suffix = SecureRandom.hex(4)
    @user = users(:one)
    login_as @user, scope: :user

    @championship = Championship.create!(
      source_id: "champ-system-status-#{@suffix}",
      name: "Campeonato Status",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-system-status-#{@suffix}",
      championship: @championship,
      name: "Sub 18"
    )

    @team = Team.create!(
      source_id: "team-system-status-#{@suffix}",
      entity: Entity.create!(source_id: "entity-system-status-#{@suffix}", name: "Equipe Status"),
      category: @category,
      name: "Equipe Status"
    )

    @opponent_team = Team.create!(
      source_id: "team-system-status-opponent-#{@suffix}",
      entity: Entity.create!(source_id: "entity-system-status-opponent-#{@suffix}", name: "Equipe Adversária"),
      category: @category,
      name: "Equipe Adversária"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-system-status-#{@suffix}",
      team: @team,
      category: @category,
      name: "Atleta Status"
    )

    @match = Match.create!(
      source_id: "match-system-status-#{@suffix}",
      championship: @championship,
      category: @category,
      code: "JS#{@suffix}",
      phase: "grupos",
      team_a: @team,
      team_b: @opponent_team
    )

    @participation = MatchParticipation.find_by!(
      match: @match,
      team: @team,
      athlete: @athlete
    )
  end

  teardown do
    @championship&.destroy!
    Warden.test_reset!
  end

  test "changes an athlete status inline from the match edit screen" do
    visit edit_match_path(@match)

    select "Confirmado", from: "match_participation_status_team_a_#{@athlete.id}"
    assert_equal "confirmado", find("#match_participation_status_team_a_#{@athlete.id}").value

    accept_confirm do
      find("a[aria-label='Remover participação']").click
    end

    assert_no_selector("a[aria-label='Remover participação']", wait: 5)
    assert_nil MatchParticipation.find_by(id: @participation.id)
    assert_current_path match_path(@match)
    assert_text "Participação removida."
  end
end
