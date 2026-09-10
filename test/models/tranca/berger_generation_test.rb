require "test_helper"

class Tranca::BergerGenerationTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(source_id: SecureRandom.uuid, name: "Berger", season: 2026, modality: :tranca)
    @category = @championship.ensure_tranca_onboarding_category!
    @duplas = 5.times.map do |index|
      Tranca::Dupla.create!(source_id: SecureRandom.uuid, championship: @championship,
        category: @category, name: "Dupla #{index}")
    end
  end

  test "saved order survives renaming and each pair plays once" do
    5.times do |index|
      Tranca::CompetitionFlow.new(@championship).generate_round!(phase: "classificatoria", round_number: index + 1)
      @duplas.first.update!(name: "Renomeada #{index}")
    end
    matches = @championship.tranca_partidas.to_a
    assert_equal 10, matches.size
    assert_equal 10, matches.map { |match| [match.dupla_a_id, match.dupla_b_id].sort }.uniq.size
    assert_equal 1, matches.map { |match| match.source_data["round_robin_order"] }.uniq.size
    byes = matches.group_by(&:round_number).values.flat_map { |round| round.first.source_data["bye_ids"] }
    assert_equal @duplas.map(&:id).sort, byes.sort
  end

  test "repeated generation keeps matches and results intact" do
    flow = Tranca::CompetitionFlow.new(@championship)
    round = flow.generate_round!(phase: "classificatoria", round_number: 1)
    match = round.partidas.first
    match.update!(score_a: 7, score_b: 3, status: :finalizado)
    before = round.partidas.order(:id).map(&:attributes)
    assert_no_difference ["Tranca::Rodada.count", "Tranca::Partida.count"] do
      assert_equal round.id, flow.generate_round!(phase: "classificatoria", round_number: 1).id
    end
    assert_equal before, round.partidas.reload.order(:id).map(&:attributes)
  end

  test "roster changes are rejected without creating a partial round" do
    flow = Tranca::CompetitionFlow.new(@championship)
    flow.generate_round!(phase: "classificatoria", round_number: 1)
    Tranca::Dupla.create!(source_id: SecureRandom.uuid, championship: @championship, category: @category, name: "Extra")
    assert_no_difference ["Tranca::Rodada.count", "Tranca::Partida.count"] do
      assert_raises(Tranca::CompetitionFlow::InvalidScheduleError) do
        flow.generate_round!(phase: "classificatoria", round_number: 2)
      end
    end
  end
end
