require "test_helper"

class ChampionshipCompetitionModesTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-competition-modes",
      name: "Campeonato Modos",
      season: 2026,
      format: {
        "mode" => "grupos_mata_mata",
        "qualifiedPerGroup" => 2
      }
    )

    @category = Category.create!(
      source_id: "cat-competition-modes",
      championship: @championship,
      name: "Sub 18"
    )

    @teams = {}
    %w[A1 A2 A3 A4 B1 B2 B3 B4].each do |label|
      entity = Entity.create!(
        source_id: "entity-#{label.downcase}-competition-modes",
        name: "Escola #{label}"
      )

      @teams[label] = Team.create!(
        source_id: "team-#{label.downcase}-competition-modes",
        entity: entity,
        category: @category,
        name: "Time #{label}"
      )
    end
  end

  test "rebuilds standings separately for each group key" do
    play_classification_match!(code: "A1", group_key: "A", team_a: @teams.fetch("A1"), team_b: @teams.fetch("A2"), score_a: 4, score_b: 0)
    play_classification_match!(code: "A2", group_key: "A", team_a: @teams.fetch("A3"), team_b: @teams.fetch("A4"), score_a: 1, score_b: 0)
    play_classification_match!(code: "B1", group_key: "B", team_a: @teams.fetch("B1"), team_b: @teams.fetch("B2"), score_a: 3, score_b: 0)
    play_classification_match!(code: "B2", group_key: "B", team_a: @teams.fetch("B3"), team_b: @teams.fetch("B4"), score_a: 2, score_b: 0)

    rows_a = @championship.standing_rows.where(category: @category, group_key: "A").order(:position)
    rows_b = @championship.standing_rows.where(category: @category, group_key: "B").order(:position)

    assert_equal ["Time A1", "Time A3", "Time A4", "Time A2"], rows_a.map { |row| row.team.name }
    assert_equal ["Time B1", "Time B3", "Time B4", "Time B2"], rows_b.map { |row| row.team.name }
    assert_equal [true, true, false, false], rows_a.pluck(:qualified)
    assert_equal [true, true, false, false], rows_b.pluck(:qualified)
  end

  test "creates knockout pairings from qualified group winners" do
    play_classification_match!(code: "A1", group_key: "A", team_a: @teams.fetch("A1"), team_b: @teams.fetch("A2"), score_a: 4, score_b: 0)
    play_classification_match!(code: "A2", group_key: "A", team_a: @teams.fetch("A3"), team_b: @teams.fetch("A4"), score_a: 1, score_b: 0)
    play_classification_match!(code: "B1", group_key: "B", team_a: @teams.fetch("B1"), team_b: @teams.fetch("B2"), score_a: 3, score_b: 0)

    assert_nil @championship.matches.find_by(category: @category, phase: "mata_mata", round_number: 1)

    play_classification_match!(code: "B2", group_key: "B", team_a: @teams.fetch("B3"), team_b: @teams.fetch("B4"), score_a: 2, score_b: 0)

    round_one_matches = @championship.matches.where(category: @category, phase: "mata_mata", round_number: 1).order(:code)

    assert_equal 2, round_one_matches.count
    assert_equal [@teams.fetch("A1"), @teams.fetch("A3")], round_one_matches.map(&:team_a)
    assert_equal [@teams.fetch("B3"), @teams.fetch("B1")], round_one_matches.map(&:team_b)
  end

  test "defaults to one match per opponent in points mode" do
    assert_equal 1, @championship.matches_per_opponent
    assert_equal "1 vez por adversário", @championship.matches_per_opponent_label
  end

  test "finalizes registrations by closing signups and creating the initial group schedule" do
    created_matches = @championship.finalize_registrations!

    assert_equal 28, created_matches.size
    assert_not @championship.reload.team_signup_enabled?
    assert_equal "em_andamento", @championship.status
    assert_equal 28, @championship.matches.where(category: @category, phase: "grupos").count
    assert_equal ["A"], @championship.standing_rows.where(category: @category).pluck(:group_key).uniq
  end

  private

  def play_classification_match!(code:, group_key:, team_a:, team_b:, score_a:, score_b:)
    match = Match.create!(
      source_id: "match-#{code}-competition-modes",
      championship: @championship,
      category: @category,
      code: code,
      phase: "grupos",
      group_key: group_key,
      team_a: team_a,
      team_b: team_b
    )

    match.update!(
      score_a: score_a,
      score_b: score_b,
      status: :finalizado
    )
    match.sync_competition_state!
    @championship.reload
    match.reload
  end
end
