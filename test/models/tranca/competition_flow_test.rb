require "test_helper"

class Tranca::CompetitionFlowTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-flow",
      name: "Fluxo Tranca",
      season: 2026,
      modality: :tranca
    )

    @category = Category.create!(
      source_id: "cat-tranca-flow",
      championship: @championship,
      name: "Livre"
    )

    @entity = Entity.create!(
      source_id: "entity-tranca-flow",
      name: "Associação Tranca"
    )

    @dupla_a = Tranca::Dupla.create!(
      source_id: "dupla-tranca-flow-a",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Carlos / Ana"
    )

    @dupla_b = Tranca::Dupla.create!(
      source_id: "dupla-tranca-flow-b",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Pedro / Maria"
    )
  end

  test "generates round, mesa, result and classification" do
    flow = Tranca::CompetitionFlow.new(@championship)

    rodada = flow.generate_round!(phase: "classificatoria", round_number: 1)

    assert_equal 1, rodada.partidas.count
    assert_equal 1, @championship.tranca_partidas.count

    flow.assign_mesas!(rodada)
    partida = rodada.partidas.first

    assert_equal "Mesa 1", partida.tranca_mesa.name

    flow.record_result!(partida: partida, score_a: 2, score_b: 1, status: :finalizado)

    row = @championship.tranca_classificacao_rows.order(position: :asc).first

    assert_equal @dupla_a, row.tranca_dupla
    assert_equal 3, row.points
    assert_equal 1, row.wins
    assert_equal 1, row.played
  end

  test "recalculates score from detailed hands" do
    flow = Tranca::CompetitionFlow.new(@championship)
    rodada = flow.generate_round!(phase: "classificatoria", round_number: 1)
    flow.assign_mesas!(rodada)
    partida = rodada.partidas.first

    flow.record_result!(
      partida: partida,
      score_a: nil,
      score_b: nil,
      status: :finalizado,
      maos_attributes: [
        {
          numero: 1,
          pontos_a: 10,
          pontos_b: 6,
          canastra_limpa_a: true,
          tres_vermelho_a: true
        },
        {
          numero: 2,
          pontos_a: 7,
          pontos_b: 9,
          batida_b: true,
          desconto_b: 1
        }
      ]
    )

    partida.reload

    assert_equal 17, partida.score_a
    assert_equal 15, partida.score_b
    assert_equal 2, partida.maos.count
    assert_equal 3, @championship.tranca_classificacao_rows.find_by!(tranca_dupla: @dupla_a).points
  end

  test "avoids repeating classificatoria matchups in the next round" do
    extra_duplas = %w[Bruna Felipe Gabriela].map do |name|
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-flow-#{name.downcase}",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "#{name} / Dupla"
      )
    end

    flow = Tranca::CompetitionFlow.new(@championship)
    first_round = flow.generate_round!(phase: "classificatoria", round_number: 1)
    second_round = flow.generate_round!(phase: "classificatoria", round_number: 2)

    first_matchups = first_round.partidas.map { |partida| [ partida.dupla_a_id, partida.dupla_b_id ].sort }
    second_matchups = second_round.partidas.map { |partida| [ partida.dupla_a_id, partida.dupla_b_id ].sort }

    assert_equal 3, extra_duplas.size
    assert_equal 2, first_matchups.size
    assert_equal 2, second_matchups.size
    assert_empty first_matchups & second_matchups
  end

  test "stops classificatoria when every matchup has already happened" do
    flow = Tranca::CompetitionFlow.new(@championship)
    flow.generate_round!(phase: "classificatoria", round_number: 1)
    first_match = @championship.tranca_partidas.first
    flow.record_result!(partida: first_match, score_a: 2, score_b: 1, status: :finalizado)

    assert_raises(Tranca::CompetitionFlow::NoAvailableMatchupsError) do
      flow.generate_round!(phase: "classificatoria", round_number: 2)
    end
  end

  test "generates knockout bracket and advances winners to the next round" do
    championship = Championship.create!(
      source_id: "champ-tranca-knockout",
      name: "Tranca Mata-Mata",
      season: 2026,
      modality: :tranca
    )

    category = Category.create!(
      source_id: "cat-tranca-knockout",
      championship: championship,
      name: "Livre"
    )

    entity = Entity.create!(
      source_id: "entity-tranca-knockout",
      name: "Liga Tranca"
    )

    duplas = %w[Alpha Beta Gamma Omega].map do |name|
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-knockout-#{name.downcase}",
        championship: championship,
        category: category,
        entity: entity,
        name: "#{name} / Dupla"
      )
    end

    flow = Tranca::CompetitionFlow.new(championship)
    rodada = flow.generate_round!(phase: "mata_mata", round_number: 1)

    assert_equal 2, rodada.partidas.count
    assert_equal [ duplas[0].name, duplas[3].name ], rodada.partidas.order(:id).first.then { |partida| [ partida.dupla_a, partida.dupla_b ] }

    primeira, segunda = rodada.partidas.order(:id).to_a

    flow.record_result!(partida: primeira, score_a: 7, score_b: 4, status: :finalizado)
    flow.record_result!(partida: segunda, score_a: 6, score_b: 5, status: :finalizado)

    round_two = championship.tranca_rodadas.find_by!(phase: "mata_mata", round_number: 2)
    assert_equal 1, round_two.partidas.count
    assert_equal [ duplas[0].name, duplas[1].name ], round_two.partidas.first.then { |partida| [ partida.dupla_a, partida.dupla_b ] }

    assert_not flow.knockout_finished?

    flow.record_result!(partida: round_two.partidas.first, score_a: 8, score_b: 6, status: :finalizado)

    assert flow.knockout_finished?
  end

  test "fills an already created next knockout round after the previous one is finalized" do
    championship = Championship.create!(
      source_id: "champ-tranca-knockout-precreated",
      name: "Tranca Mata-Mata Pré-Criada",
      season: 2026,
      modality: :tranca
    )

    category = Category.create!(
      source_id: "cat-tranca-knockout-precreated",
      championship: championship,
      name: "Livre"
    )

    entity = Entity.create!(
      source_id: "entity-tranca-knockout-precreated",
      name: "Liga Tranca"
    )

    duplas = %w[Alpha Beta Gamma Omega].map do |name|
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-knockout-precreated-#{name.downcase}",
        championship: championship,
        category: category,
        entity: entity,
        name: "#{name} / Dupla"
      )
    end

    flow = Tranca::CompetitionFlow.new(championship)
    round_one = flow.generate_round!(phase: "mata_mata", round_number: 1)
    flow.generate_round!(phase: "mata_mata", round_number: 2)

    assert_equal 0, championship.tranca_rodadas.find_by!(phase: "mata_mata", round_number: 2).partidas.count

    primeira, segunda = round_one.partidas.order(:id).to_a

    flow.record_result!(partida: primeira, score_a: 7, score_b: 4, status: :finalizado)
    flow.record_result!(partida: segunda, score_a: 6, score_b: 5, status: :finalizado)

    round_two = championship.tranca_rodadas.find_by!(phase: "mata_mata", round_number: 2)
    assert_equal 1, round_two.partidas.count
    assert_equal [ duplas[0].name, duplas[1].name ], round_two.partidas.first.then { |partida| [ partida.dupla_a, partida.dupla_b ] }
  end
end
