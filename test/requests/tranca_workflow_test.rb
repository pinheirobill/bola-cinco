require "test_helper"

class TrancaWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)

    @championship = Championship.create!(
      source_id: "champ-tranca-workflow",
      name: "Fluxo Tranca Web",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-tranca-workflow",
      championship: @championship,
      name: "Livre"
    )

    @entity = Entity.create!(
      source_id: "entity-tranca-workflow",
      name: "Associação Tranca"
    )

    @dupla_a = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-a",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Carlos / Ana"
    )

    @dupla_b = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-b",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Pedro / Maria"
    )
  end

  test "runs the direct tranca operational flow" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    assert_redirected_to rodadas_championship_path(@championship)
    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)

    post generate_tranca_mesas_championship_path(@championship), params: {
      rodada_id: rodada.id
    }

    partida = rodada.partidas.first
    assert_equal "Mesa 1", partida.reload.tranca_mesa.name

    patch update_tranca_partida_championship_path(@championship, partida_id: partida.id), params: {
      tranca_partida: {
        score_a: 2,
        score_b: 1,
        status: "finalizado"
      }
    }

    assert_redirected_to partidas_championship_path(@championship)
    assert_equal 2, partida.reload.score_a
    assert_equal 1, partida.score_b
    assert_equal 1, @championship.tranca_classificacao_rows.find_by!(tranca_dupla: @dupla_a).position

    patch rebuild_tranca_classificacao_championship_path(@championship)

    assert_redirected_to classificacao_championship_path(@championship)
    assert_equal 3, @championship.tranca_classificacao_rows.find_by!(tranca_dupla: @dupla_a).points
  end

  test "launches detailed hand scoring through the same result endpoint" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    post generate_tranca_mesas_championship_path(@championship), params: {
      rodada_id: rodada.id
    }

    partida = rodada.partidas.first

    patch update_tranca_partida_championship_path(@championship, partida_id: partida.id), params: {
      tranca_partida: {
        status: "finalizado",
        maos_attributes: {
          "0" => {
            numero: 1,
            pontos_a: 10,
            pontos_b: 6,
            canastra_limpa_a: "1"
          },
          "1" => {
            numero: 2,
            pontos_a: 7,
            pontos_b: 9,
            batida_b: "1",
            desconto_b: 1
          }
        }
      }
    }

    assert_redirected_to partidas_championship_path(@championship)
    partida.reload

    assert_equal 17, partida.score_a
    assert_equal 15, partida.score_b
    assert_equal 2, partida.maos.count
    assert_equal 3, @championship.tranca_classificacao_rows.find_by!(tranca_dupla: @dupla_a).points
  end

  test "creates a knockout round and auto-generates the next bracket round" do
    additional_duplas = [
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-workflow-c",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Alpha / Carol"
      ),
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-workflow-d",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Omega / Dora"
      )
    ]

    post generate_tranca_round_championship_path(@championship), params: {
      phase: "mata_mata",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "mata_mata", round_number: 1)
    assert_equal 2, rodada.partidas.count

    partidas = rodada.partidas.order(:id).to_a
    patch update_tranca_partida_championship_path(@championship, partida_id: partidas.first.id), params: {
      tranca_partida: {
        score_a: 7,
        score_b: 4,
        status: "finalizado"
      }
    }

    patch update_tranca_partida_championship_path(@championship, partida_id: partidas.second.id), params: {
      tranca_partida: {
        score_a: 6,
        score_b: 5,
        status: "finalizado"
      }
    }

    assert Tranca::Rodada.exists?(championship: @championship, phase: "mata_mata", round_number: 2)
    round_two = @championship.tranca_rodadas.find_by!(phase: "mata_mata", round_number: 2)
    assert_equal 1, round_two.partidas.count
    assert_equal [additional_duplas.first.name, @dupla_a.name], [round_two.partidas.first.dupla_a, round_two.partidas.first.dupla_b]
  end
end
