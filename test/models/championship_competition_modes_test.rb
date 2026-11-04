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

  test "rebuilds the previous and current standings when a finalized match changes group key" do
    moved_match = play_classification_match!(code: "A1", group_key: "A", team_a: @teams.fetch("A1"), team_b: @teams.fetch("A2"), score_a: 4, score_b: 0)
    play_classification_match!(code: "A2", group_key: "A", team_a: @teams.fetch("A3"), team_b: @teams.fetch("A4"), score_a: 1, score_b: 0)

    moved_match.update!(group_key: "B")
    moved_match.sync_competition_state!
    @championship.reload

    rows_a = @championship.standing_rows.where(category: @category, group_key: "A").order(:position)
    rows_b = @championship.standing_rows.where(category: @category, group_key: "B").order(:position)

    assert_equal ["Time A3", "Time A4"], rows_a.map { |row| row.team.name }
    assert_equal ["Time A1", "Time A2"], rows_b.map { |row| row.team.name }
    assert_equal [3, 0], rows_b.pluck(:points)
    assert_equal [3, 0], rows_a.pluck(:points)
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

  test "labels the team match limit when configured" do
    @championship.update!(format: @championship.format_data.merge("matchesPerTeam" => 4))

    assert_equal 4, @championship.matches_per_team
    assert_equal "4 jogos por equipe", @championship.matches_per_team_label
    assert_includes @championship.matches_count_explanation, "4 jogos por equipe"
  end

  test "finalizes registrations with a team match limit" do
    @championship.update!(format: @championship.format_data.merge("matchesPerTeam" => 4))

    created_matches = @championship.finalize_registrations!

    assert_equal 16, created_matches.size

    counts = Hash.new(0)
    created_matches.each do |match|
      counts[match.team_a_id] += 1
      counts[match.team_b_id] += 1
    end

    assert_equal [4], counts.values.uniq
  end

  test "finalizes registrations by closing signups and creating the initial group schedule" do
    created_matches = @championship.finalize_registrations!

    assert_equal 28, created_matches.size
    assert_not @championship.reload.team_signup_enabled?
    assert_equal "em_andamento", @championship.status
    assert_equal 28, @championship.matches.where(category: @category, phase: "grupos").count
    assert_equal ["A"], @championship.standing_rows.where(category: @category).pluck(:group_key).uniq
  end

  test "uses category-specific cross-group matches and a single overall standings group" do
    category, teams = create_category_with_teams("Pre Mirim", %w[P1 P2 P3 P4 P5 P6])
    configure_category(category, "mode" => "pontuacao", "groupCount" => 2, "schedule" => "cross_groups")

    @championship.finalize_registrations!
    matches = @championship.matches.where(category: category, phase: "grupos")

    assert_equal 9, matches.count
    assert_equal ["Geral"], matches.distinct.pluck(:group_key)
    matches.each do |match|
      assert_not_equal teams.index(match.team_a).even?, teams.index(match.team_b).even?
      match.update!(score_a: 1, score_b: 0, status: :finalizado)
      match.sync_competition_state!
    end

    rows = @championship.standing_rows.where(category: category, group_key: "Geral").order(:position)
    assert_equal teams.map(&:id).sort, rows.map(&:team_id).sort
    assert_equal [3, 3, 3, 3, 3, 3], rows.map(&:played)
    assert_equal [9, 9, 9, 0, 0, 0], rows.map(&:points).sort.reverse
  end

  test "creates all round-robin matches for a category with one group" do
    category, = create_category_with_teams("Infantil", %w[I1 I2 I3 I4])
    configure_category(category, "mode" => "pontuacao", "groupCount" => 1, "schedule" => "within_groups")

    @championship.finalize_registrations!
    matches = @championship.matches.where(category: category, phase: "grupos")

    assert_equal 6, matches.count
    assert_equal ["A"], matches.distinct.pluck(:group_key)
  end

  test "category-specific no-limit setting preserves the full round robin despite a global team cap" do
    category, = create_category_with_teams("Infantil sem limite", %w[IL1 IL2 IL3 IL4])
    @championship.update!(format: @championship.format_data.merge("matchesPerTeam" => 2))
    configure_category(category, "mode" => "pontuacao", "groupCount" => 1, "schedule" => "within_groups", "matchesPerTeam" => 0)

    @championship.finalize_registrations!

    assert_equal 6, @championship.matches.where(category: category, phase: "grupos").count
  end

  test "does not finalize a category when linked teams do not match its configured count" do
    category, = create_category_with_teams("Pré Mirim incompleto", %w[PMI1 PMI2 PMI3 PMI4 PMI5])
    configure_category(category, "mode" => "pontuacao", "teamCount" => 6, "groupCount" => 2, "schedule" => "cross_groups")

    error = assert_raises(ArgumentError) { @championship.finalize_registrations! }

    assert_includes error.message, "Pré Mirim incompleto: 5 de 6 equipes"
    assert @championship.reload.team_signup_enabled?
    assert_empty @championship.matches.where(category: category, phase: "grupos")
  end

  test "sends the best campaign directly to a final after the round robin" do
    category, teams = create_category_with_teams("Juvenil", %w[J1 J2 J3])
    configure_category(category, "mode" => "melhor_campanha_final", "groupCount" => 1)

    @championship.finalize_registrations!
    classification_matches = @championship.matches.where(category: category, phase: "grupos")
    assert_equal 3, classification_matches.count

    classification_matches.each do |match|
      winner = [match.team_a, match.team_b].include?(teams.first) ? teams.first : teams.second
      score_a, score_b = match.team_a == winner ? [2, 0] : [0, 2]
      match.update!(score_a: score_a, score_b: score_b, status: :finalizado)
      match.sync_competition_state!
    end

    semifinal = @championship.matches.find_by!(category: category, phase: "mata_mata", round_number: 1)
    final = @championship.matches.find_by!(category: category, phase: "mata_mata", round_number: 2)
    assert_equal [teams.second, teams.third].sort_by(&:id), [semifinal.team_a, semifinal.team_b].sort_by(&:id)
    assert_equal teams.first, final.team_a
    assert_nil final.team_b

    semifinal_winner = semifinal.team_b
    semifinal.update!(score_a: 0, score_b: 1, status: :finalizado)
    semifinal.sync_competition_state!
    assert_equal semifinal_winner, final.reload.team_b
  end

  test "finalizes a championship with a different schedule for every category" do
    pre_mirim, = create_category_with_teams("Pre Mirim Misto", %w[PM1 PM2 PM3 PM4 PM5 PM6])
    mirim, = create_category_with_teams("Mirim Misto", %w[M1 M2 M3 M4 M5 M6])
    infantil, = create_category_with_teams("Infantil Misto", %w[I1 I2 I3 I4])
    juvenil, = create_category_with_teams("Juvenil Misto", %w[J1 J2 J3])
    configure_category(pre_mirim, "mode" => "pontuacao", "groupCount" => 2, "schedule" => "cross_groups")
    configure_category(mirim, "mode" => "pontuacao", "groupCount" => 2, "schedule" => "cross_groups")
    configure_category(infantil, "mode" => "pontuacao", "groupCount" => 1, "schedule" => "within_groups")
    configure_category(juvenil, "mode" => "melhor_campanha_final", "groupCount" => 1)

    @championship.finalize_registrations!

    assert_equal 9, @championship.matches.where(category: pre_mirim, phase: "grupos").count
    assert_equal 9, @championship.matches.where(category: mirim, phase: "grupos").count
    assert_equal 6, @championship.matches.where(category: infantil, phase: "grupos").count
    assert_equal 3, @championship.matches.where(category: juvenil, phase: "grupos").count
    assert_equal "Geral", @championship.matches.where(category: pre_mirim, phase: "grupos").first.group_key
    assert_equal "Geral", @championship.matches.where(category: mirim, phase: "grupos").first.group_key
    assert_equal "A", @championship.matches.where(category: infantil, phase: "grupos").first.group_key
  end

  private

  def configure_category(category, attributes)
    category_formats = @championship.format_data.fetch("categoryFormats", {}).deep_dup
    category_formats[category.id.to_s] = attributes
    @championship.update!(format: @championship.format_data.merge("categoryFormats" => category_formats))
  end

  def create_category_with_teams(name, labels)
    category = Category.create!(
      source_id: "cat-#{name.parameterize}-competition-modes",
      championship: @championship,
      name: name
    )
    teams = labels.map do |label|
      entity = Entity.create!(
        source_id: "entity-#{label.downcase}-#{name.parameterize}-competition-modes",
        name: "Escola #{label}"
      )
      Team.create!(
        source_id: "team-#{label.downcase}-#{name.parameterize}-competition-modes",
        entity: entity,
        category: category,
        name: "Time #{label}"
      )
    end
    [category, teams]
  end

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
