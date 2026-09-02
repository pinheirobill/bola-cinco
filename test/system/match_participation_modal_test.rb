require "application_system_test_case"
require "securerandom"

class MatchParticipationModalTest < ApplicationSystemTestCase
  setup do
    @suffix = SecureRandom.hex(4)
    @user = users(:one)
    login_as @user, scope: :user

    @championship = Championship.create!(
      source_id: "champ-system-modal-#{@suffix}",
      name: "Campeonato System Modal",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-system-modal-#{@suffix}",
      championship: @championship,
      name: "Sub 18"
    )

    @team_a = Team.create!(
      source_id: "team-system-modal-a-#{@suffix}",
      entity: Entity.create!(source_id: "entity-system-modal-a-#{@suffix}", name: "Equipe Modal A"),
      category: @category,
      name: "Equipe Modal A"
    )

    @team_b = Team.create!(
      source_id: "team-system-modal-b-#{@suffix}",
      entity: Entity.create!(source_id: "entity-system-modal-b-#{@suffix}", name: "Equipe Modal B"),
      category: @category,
      name: "Equipe Modal B"
    )

    Athlete.create!(
      source_id: "athlete-system-modal-a-#{@suffix}",
      team: @team_a,
      category: @category,
      name: "Atleta Modal A"
    )

    Athlete.create!(
      source_id: "athlete-system-modal-b-#{@suffix}",
      team: @team_b,
      category: @category,
      name: "Atleta Modal B"
    )

    @match = Match.create!(
      source_id: "match-system-modal-#{@suffix}",
      championship: @championship,
      category: @category,
      code: "JG900",
      phase: "grupos"
    )

    @match.update!(team_a: @team_a, team_b: @team_b)
  end

  teardown do
    Athlete.where(team: [@team_a, @team_b]).find_each(&:destroy!)
    @match&.destroy!
    @team_a&.destroy!
    @team_b&.destroy!
    @category&.destroy!
    @championship&.destroy!
    Warden.test_reset!
  end

  test "opens the participation modal from the team button and preselects the team" do
    visit edit_match_path(@match)

    assert_equal "function", evaluate_script("typeof window.BolaCinco?.openMatchParticipationModal")

    find_all("button", text: "Atletas").first.click

    assert_selector("dialog#match-participation-modal[open]", visible: true)
    assert_equal @team_a.id.to_s, find('select[name="match_participation[team_id]"]').value
    assert_text "Adicionar participação"
  end
end
