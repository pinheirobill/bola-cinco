require "test_helper"

class Tranca::SecondStageBuilderTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-second-stage",
      name: "2ª Etapa da Tranca",
      season: 2026,
      modality: :tranca
    )
    @category = Category.create!(
      source_id: "cat-tranca-second-stage",
      championship: @championship,
      name: "Livre"
    )
    @entity = Entity.create!(
      source_id: "entity-tranca-second-stage",
      name: "Associação Segunda Etapa"
    )
    @duplas = 16.times.map do |index|
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-second-stage-#{index + 1}",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Dupla #{index + 1}"
      )
    end
    @groups = %w[A B C D].each_with_index.to_h do |group_key, group_index|
      [group_key, @duplas.slice(group_index * 4, 4).map(&:id)]
    end
  end

  test "creates three rounds, twenty four matches and eight tables per round" do
    rounds = Tranca::SecondStageBuilder.new(@championship).create!(groups: @groups)

    assert_equal 3, rounds.size
    assert_equal 3, @championship.tranca_rodadas.for_stage(2).count
    assert_equal 24, @championship.tranca_partidas.for_stage(2).count
    assert_equal 24, @championship.tranca_mesas.where(tranca_rodada_id: rounds.map(&:id)).count

    rounds.each do |round|
      assert_equal 8, round.partidas.count
      assert_equal 8, round.mesas.count
      assert_equal (1..8).map { |number| "Mesa #{number}" }, round.mesas.order(:id).pluck(:name)
      presenter = BolaCinco::TrancaProgramacaoPresenter.new(@championship, round.partidas.order(:id))
      assert_equal (1..8).map(&:to_s), presenter.sections.flat_map { |section| section[:rows].map { |row| row[:mesa] } }
    end

    @duplas.each do |dupla|
      appearances = @championship.tranca_partidas.for_stage(2)
        .where("dupla_a_id = :id OR dupla_b_id = :id", id: dupla.id)
        .count
      assert_equal 3, appearances
    end
  end

  test "uses the pairing order defined by the spreadsheet" do
    Tranca::SecondStageBuilder.new(@championship).create!(groups: @groups)

    group_ids = @groups.fetch("A")
    expected_pairs = {
      1 => [[group_ids[0], group_ids[1]], [group_ids[3], group_ids[2]]],
      2 => [[group_ids[3], group_ids[0]], [group_ids[2], group_ids[1]]],
      3 => [[group_ids[0], group_ids[2]], [group_ids[1], group_ids[3]]]
    }

    expected_pairs.each do |round_number, pairs|
      matches = @championship.tranca_partidas
        .for_stage(2)
        .where(round_number: round_number, group_key: "A")
        .order(:id)

      assert_equal pairs, matches.pluck(:dupla_a_id, :dupla_b_id)
      assert_equal ["Mesa 1", "Mesa 2"], matches.includes(:tranca_mesa).map { |match| match.tranca_mesa.name }
    end
  end

  test "rejects repeated duplas without creating partial records" do
    @groups["D"][3] = @groups["A"].first

    error = assert_raises(Tranca::SecondStageBuilder::InvalidSelectionError) do
      Tranca::SecondStageBuilder.new(@championship).create!(groups: @groups)
    end

    assert_equal "A mesma dupla não pode aparecer em mais de uma posição da 2ª etapa.", error.message
    assert_not @championship.tranca_rodadas.for_stage(2).exists?
    assert_not @championship.tranca_partidas.for_stage(2).exists?
  end

  test "does not overwrite an existing second stage" do
    builder = Tranca::SecondStageBuilder.new(@championship)
    builder.create!(groups: @groups)

    assert_raises(Tranca::SecondStageBuilder::InvalidSelectionError) do
      builder.create!(groups: @groups)
    end

    assert_equal 24, @championship.tranca_partidas.for_stage(2).count
  end

  test "keeps first stage generation isolated after creating the second stage" do
    Tranca::SecondStageBuilder.new(@championship).create!(groups: @groups)

    first_stage_round = Tranca::CompetitionFlow.new(@championship).generate_round!(
      phase: "classificatoria",
      round_number: 1
    )

    assert first_stage_round.first_stage?
    assert_equal 3, @championship.tranca_rodadas.for_stage(2).count
    assert_equal 1, @championship.tranca_rodadas.for_stage(1).count
  end

  test "does not rebuild first stage standings when recording a second stage result" do
    first_stage_row = @championship.tranca_classificacao_rows.create!(
      category: @category,
      tranca_dupla: @duplas.first,
      stage_number: 1,
      source_id: "tranca-first-stage-row-preserved",
      group_key: "A",
      position: 1,
      points: 9
    )
    Tranca::SecondStageBuilder.new(@championship).create!(groups: @groups)
    match = @championship.tranca_partidas.for_stage(2).first

    Tranca::CompetitionFlow.new(@championship).record_result!(
      partida: match,
      score_a: 10,
      score_b: 5,
      status: :finalizado
    )

    assert_equal 9, first_stage_row.reload.points
    assert_equal 1, @championship.tranca_classificacao_rows.for_stage(1).count
    assert_equal 4, @championship.tranca_classificacao_rows.for_stage(2).count
  end
end
