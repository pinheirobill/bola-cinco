require "test_helper"

class ChampionshipStandingsProgressionTest < ActiveSupport::TestCase
  test "updates the table as results are entered and recalculates edited scores" do
    championship = Championship.create!(
      source_id: "standings-progression-championship",
      name: "Progressão da classificação",
      season: 2026
    )
    category = Category.create!(
      source_id: "standings-progression-category",
      championship: championship,
      name: "Sub 15"
    )
    teams = %w[A B C].to_h do |label|
      entity = Entity.create!(source_id: "standings-progression-entity-#{label}", name: "Escola #{label}")
      team = Team.create!(
        source_id: "standings-progression-team-#{label}",
        entity: entity,
        category: category,
        name: "Time #{label}"
      )
      [label, team]
    end

    first_match = Match.create!(
      source_id: "standings-progression-match-1",
      championship: championship,
      category: category,
      code: "J1",
      phase: "grupos",
      group_key: "A",
      team_a: teams.fetch("A"),
      team_b: teams.fetch("B"),
      status: :agendado
    )

    second_match = Match.create!(
      source_id: "standings-progression-match-2",
      championship: championship,
      category: category,
      code: "J2",
      phase: "grupos",
      group_key: "A",
      team_a: teams.fetch("B"),
      team_b: teams.fetch("C"),
      status: :agendado
    )

    first_match.update!(score_a: 2, score_b: 0, status: :finalizado)
    first_match.sync_competition_state!

    rows = championship.standing_rows.where(category: category, group_key: "A").order(:position)
    assert_equal [["Time A", 1, 3, 2, 0], ["Time C", 0, 0, 0, 0], ["Time B", 1, 0, 0, 2]],
      rows.map { |row| [row.team.name, row.played, row.points, row.goals_for, row.goals_against] }

    second_match.update!(score_a: 1, score_b: 1, status: :finalizado)
    second_match.sync_competition_state!

    rows = championship.standing_rows.where(category: category, group_key: "A").order(:position)
    assert_equal [["Time A", 3, 2], ["Time B", 1, 1], ["Time C", 1, 1]],
      rows.map { |row| [row.team.name, row.points, row.goal_diff] }

    first_match.update!(score_a: 0, score_b: 1)
    first_match.sync_competition_state!

    rows = championship.standing_rows.where(category: category, group_key: "A").order(:position)
    assert_equal [["Time B", 4, 1], ["Time C", 1, 0], ["Time A", 0, -1]],
      rows.map { |row| [row.team.name, row.points, row.goal_diff] }
  end
end
