require "test_helper"

class SyncFootballKnockoutBracketsJobTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-sync-knockout-job",
      name: "Campeonato Knockout Sync",
      season: 2026,
      modality: :football,
      format: {
        "mode" => "mata_mata"
      }
    )

    @category = Category.create!(
      source_id: "cat-sync-knockout-job",
      championship: @championship,
      name: "Sub 18"
    )

    @teams = 8.times.map do |index|
      entity = Entity.create!(
        source_id: "entity-sync-knockout-job-#{index + 1}",
        name: "Escola #{index + 1}"
      )

      Team.create!(
        source_id: "team-sync-knockout-job-#{index + 1}",
        entity: entity,
        category: @category,
        name: "Time #{index + 1}"
      )
    end
  end

  test "fills later knockout rounds when they exist after previous results" do
    round_one_matches = build_round_with_sources!(round_number: 1, count: 4, offset: 0)
    finalize_match!(round_one_matches[0], 3, 1)
    finalize_match!(round_one_matches[1], 2, 0)
    finalize_match!(round_one_matches[2], 4, 2)
    finalize_match!(round_one_matches[3], 1, 0)

    round_two_matches = build_pending_round!(round_number: 2, count: 2)

    SyncFootballKnockoutBracketsJob.perform_now

    assert_equal [@teams[0], @teams[4]], round_two_matches.map { |match| match.reload.team_a }
    assert_equal [@teams[2], @teams[6]], round_two_matches.map { |match| match.reload.team_b }

    finalize_match!(round_two_matches[0], 2, 1)
    finalize_match!(round_two_matches[1], 5, 4)

    round_three_match = build_pending_round!(round_number: 3, count: 1).first

    SyncFootballKnockoutBracketsJob.perform_now

    assert_equal @teams[0], round_three_match.reload.team_a
    assert_equal @teams[4], round_three_match.reload.team_b
  end

  private

  def build_round_with_sources!(round_number:, count:, offset:)
    count.times.map do |index|
      Match.create!(
        source_id: "match-sync-knockout-job-r#{round_number}-#{index + 1}",
        championship: @championship,
        category: @category,
        code: "R#{round_number}-#{index + 1}",
        phase: "mata_mata",
        round_number: round_number,
        source_a: { name: @teams[offset + (index * 2)].name },
        source_b: { name: @teams[offset + (index * 2) + 1].name }
      )
    end
  end

  def build_pending_round!(round_number:, count:)
    count.times.map do |index|
      Match.create!(
        source_id: "match-sync-knockout-job-pending-r#{round_number}-#{index + 1}",
        championship: @championship,
        category: @category,
        code: "R#{round_number}-P#{index + 1}",
        phase: "mata_mata",
        round_number: round_number,
        status: :agendado
      )
    end
  end

  def finalize_match!(match, score_a, score_b)
    match.update!(
      score_a: score_a,
      score_b: score_b,
      status: :finalizado
    )
    match.sync_competition_state!
    match.reload
  end
end
