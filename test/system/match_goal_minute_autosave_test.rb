require "application_system_test_case"
require "securerandom"

class MatchGoalMinuteAutosaveTest < ApplicationSystemTestCase
  setup do
    @suffix = SecureRandom.hex(4)
    login_as users(:one), scope: :user

    @championship = Championship.create!(
      source_id: "champ-goal-autosave-#{@suffix}",
      name: "Campeonato Autosave",
      season: 2026
    )
    @category = Category.create!(
      source_id: "cat-goal-autosave-#{@suffix}",
      championship: @championship,
      name: "Sub 18"
    )
    @team_a = Team.create!(
      source_id: "team-a-goal-autosave-#{@suffix}",
      entity: Entity.create!(source_id: "entity-a-goal-autosave-#{@suffix}", name: "Equipe A"),
      category: @category,
      name: "Equipe A"
    )
    @team_b = Team.create!(
      source_id: "team-b-goal-autosave-#{@suffix}",
      entity: Entity.create!(source_id: "entity-b-goal-autosave-#{@suffix}", name: "Equipe B"),
      category: @category,
      name: "Equipe B"
    )
    @athlete = Athlete.create!(
      source_id: "athlete-goal-autosave-#{@suffix}",
      team: @team_a,
      category: @category,
      name: "Atleta Autosave"
    )
    @match = Match.create!(
      source_id: "match-goal-autosave-#{@suffix}",
      championship: @championship,
      category: @category,
      code: "JA#{@suffix}",
      phase: "grupos",
      team_a: @team_a,
      team_b: @team_b
    )
  end

  teardown do
    @match&.destroy!
    @athlete&.destroy!
    @team_a&.destroy!
    @team_b&.destroy!
    @category&.destroy!
    @championship&.destroy!
    Warden.test_reset!
  end

  test "autosaves a player's goal minute while editing the match sheet" do
    visit edit_match_path(@match)

    goal_minute = find("input[name='match[event_sheet][team_a][#{@athlete.id}][goal_minutes][]']")
    goal_minute.fill_in(with: "8")

    assert_selector("[data-autosave-form-target='status']", text: "Salvo", wait: 5)
    assert_equal 8, @match.match_events.find_by!(team: @team_a, athlete: @athlete, kind: "gol").minute
  end
end
