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
    partida.reload
    assert_equal 2, partida.score_a
    assert_equal 1, partida.score_b
    assert_includes [ @dupla_a.id, @dupla_b.id ], partida.winner_id
    assert_equal 3, @championship.tranca_classificacao_rows.find_by!(tranca_dupla_id: partida.winner_id).points

    patch rebuild_tranca_classificacao_championship_path(@championship)

    assert_redirected_to classificacao_championship_path(@championship)
    assert_equal 3, @championship.tranca_classificacao_rows.find_by!(tranca_dupla_id: partida.winner_id).points
  end

  test "shows the quick score form on tranca partida cards" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)

    post generate_tranca_mesas_championship_path(@championship), params: {
      rodada_id: rodada.id
    }

    get partidas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Placar rápido"
    assert_includes response.body, "Salvar placar"
    assert_includes response.body, "Ou use a súmula"
  end

  test "updates the duplas of a scheduled tranca partida" do
    dupla_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Joana / Bruno"
    )

    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    partida = rodada.partidas.first

    patch update_tranca_partida_championship_path(@championship, partida_id: partida.id), params: {
      tranca_partida: {
        dupla_a_id: dupla_c.id,
        dupla_b_id: @dupla_b.id
      }
    }

    assert_redirected_to rodadas_championship_path(@championship)
    partida.reload

    assert_equal dupla_c.id, partida.dupla_a_id
    assert_equal @dupla_b.id, partida.dupla_b_id
  end

  test "deletes a round and its games while no game is finalized" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }
    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    partida_id = rodada.partidas.first.id

    delete destroy_tranca_round_championship_path(@championship, rodada_id: rodada.id)

    assert_redirected_to rodadas_championship_path(@championship)
    assert_not Tranca::Rodada.exists?(rodada.id)
    assert_not Tranca::Partida.exists?(partida_id)
  end

  test "deletes a scheduled tranca partida and frees the mesa" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    post generate_tranca_mesas_championship_path(@championship), params: {
      rodada_id: rodada.id
    }

    partida = rodada.partidas.first
    mesa_id = partida.tranca_mesa_id

    delete destroy_tranca_partida_championship_path(@championship, partida_id: partida.id)

    assert_redirected_to rodadas_championship_path(@championship)
    assert_not Tranca::Partida.exists?(partida.id)
    assert_not Tranca::Mesa.exists?(mesa_id)
  end

  test "deletes a scheduled tranca key and keeps the other keys intact" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    partida_delete = rodada.partidas.first

    partida_keep = Tranca::Partida.create!(
      source_id: "partida-tranca-workflow-keep-key",
      championship: @championship,
      category: @category,
      tranca_rodada: rodada,
      code: "JG 99",
      phase: "classificatoria",
      round_number: 1,
      group_key: "Chave Z",
      dupla_a: @dupla_a,
      dupla_b: @dupla_b,
      status: :agendado
    )

    post generate_tranca_mesas_championship_path(@championship), params: {
      rodada_id: rodada.id
    }

    mesa_id = partida_delete.reload.tranca_mesa_id

    delete destroy_tranca_key_championship_path(@championship, rodada_id: rodada.id, group_key: partida_delete.group_key)

    assert_redirected_to rodadas_championship_path(@championship)
    assert_not Tranca::Partida.exists?(partida_delete.id)
    assert_not Tranca::Mesa.exists?(mesa_id)
    assert Tranca::Partida.exists?(partida_keep.id)
  end

  test "deletes a programming key across the championship and keeps other keys intact" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    partida_delete = rodada.partidas.first

    partida_keep = Tranca::Partida.create!(
      source_id: "partida-tranca-workflow-programacao-keep",
      championship: @championship,
      category: @category,
      tranca_rodada: rodada,
      code: "JG 100",
      phase: "classificatoria",
      round_number: 1,
      group_key: "Chave Z",
      dupla_a: @dupla_a,
      dupla_b: @dupla_b,
      status: :agendado
    )

    post generate_tranca_mesas_championship_path(@championship), params: {
      rodada_id: rodada.id
    }

    mesa_id = partida_delete.reload.tranca_mesa_id

    delete destroy_tranca_programacao_key_championship_path(@championship, group_key: partida_delete.group_key)

    assert_redirected_to programacao_championship_path(@championship)
    assert_not Tranca::Partida.exists?(partida_delete.id)
    assert_not Tranca::Mesa.exists?(mesa_id)
    assert Tranca::Partida.exists?(partida_keep.id)
    assert_not @championship.tranca_classificacao_rows.where(group_key: partida_delete.group_key).exists?
  end

  test "updates a dupla inside a classificatoria key" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    dupla_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Luana / Carol"
    )

    row = @championship.tranca_classificacao_rows.order(:position).first

    patch update_tranca_classificacao_row_championship_path(@championship, row_id: row.id), params: {
      tranca_classificacao_row: {
        tranca_dupla_id: dupla_c.id
      }
    }

    assert_redirected_to classificacao_championship_path(@championship)
    assert_equal dupla_c.id, row.reload.tranca_dupla_id
  end

  test "replaces a classificatoria row with a recent rejected team" do
    source_championship = Championship.create!(
      source_id: "champ-tranca-workflow-source",
      name: "Fluxo Tranca Base",
      season: 2025,
      modality: :tranca,
      status: :em_andamento
    )

    source_category = Category.create!(
      source_id: "cat-tranca-workflow-source",
      championship: source_championship,
      name: "Livre"
    )

    source_team = Team.create!(
      source_id: "team-tranca-workflow-source",
      category: source_category,
      entity: @entity,
      name: "Lucia / Rita",
      registration_status: :rejeitada,
      finance_status: :pendente
    )

    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    row = @championship.tranca_classificacao_rows.order(:position).first

    get classificacao_championship_path(@championship)
    assert_response :success
    assert_includes response.body, "Rejeitada"

    patch replace_tranca_classificacao_row_from_recent_team_championship_path(@championship, row_id: row.id, team_id: source_team.id)

    assert_redirected_to classificacao_championship_path(@championship)
    assert_equal "Lucia / Rita", row.reload.tranca_dupla.name
  end

  test "adds a new classificatoria row with an already registered dupla" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    row = @championship.tranca_classificacao_rows.order(:position).first
    dupla_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Luana / Carol"
    )
    Tranca::ClassificacaoRow.create!(
      source_id: "tranca-standing-row-workflow-extra",
      championship: @championship,
      category: @category,
      tranca_dupla: dupla_c,
      group_key: "B",
      position: 1
    )
    original_count = @championship.tranca_classificacao_rows.where(category_id: @category.id, group_key: row.group_key).count
    original_last_position = @championship.tranca_classificacao_rows.where(category_id: @category.id, group_key: row.group_key).maximum(:position)

    post append_tranca_classificacao_row_from_existing_dupla_championship_path(@championship), params: {
      category_id: @category.id,
      group_key: row.group_key,
      tranca_classificacao_row: {
        tranca_dupla_id: dupla_c.id
      }
    }

    assert_redirected_to classificacao_championship_path(@championship)

    appended_rows = @championship.tranca_classificacao_rows.where(category_id: @category.id, group_key: row.group_key).order(:position)
    assert_equal original_count + 1, appended_rows.count
    assert_equal dupla_c.id, appended_rows.last.tranca_dupla_id
    assert_equal original_last_position + 1, appended_rows.last.position

    get classificacao_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Luana / Carol"
  end

  test "removes a dupla from a classificatoria key and shifts the remaining rows" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    row = @championship.tranca_classificacao_rows.order(:position).first
    next_row = @championship.tranca_classificacao_rows.order(:position).second
    next_row_position = next_row.position

    delete destroy_tranca_classificacao_row_championship_path(@championship, row_id: row.id)

    assert_redirected_to classificacao_championship_path(@championship)
    assert_not Tranca::ClassificacaoRow.exists?(row.id)
    assert_equal next_row_position - 1, next_row.reload.position
  end

  test "shows the rounds page even when a classificatoria partida has a missing dupla" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    Tranca::Partida.create!(
      source_id: "partida-tranca-workflow-missing-dupla",
      championship: @championship,
      category: @category,
      tranca_rodada: rodada,
      code: "JG 99",
      phase: "classificatoria",
      round_number: 1,
      group_key: "Chave 1",
      dupla_a: @dupla_a,
      dupla_b: nil
    )

    get rodadas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Rodada 1"
  end

  test "does not delete a round with a finalized game" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }
    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    partida = rodada.partidas.first
    patch update_tranca_partida_championship_path(@championship, partida_id: partida.id), params: {
      tranca_partida: { score_a: 2, score_b: 1, status: "finalizado" }
    }

    delete destroy_tranca_round_championship_path(@championship, rodada_id: rodada.id)

    assert_redirected_to rodadas_championship_path(@championship)
    assert Tranca::Rodada.exists?(rodada.id)
    assert_equal "finalizado", partida.reload.status
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
    assert_includes [ @dupla_a.id, @dupla_b.id ], partida.winner_id
    assert_equal 3, @championship.tranca_classificacao_rows.find_by!(tranca_dupla_id: partida.winner_id).points
  end

  test "preserves negative hand values before saving tranca results" do
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
            pontos_b: "-6",
            desconto_b: 1
          },
          "1" => {
            numero: 2,
            pontos_a: "-7",
            pontos_b: 9
          }
        }
      }
    }

    assert_redirected_to partidas_championship_path(@championship)
    partida.reload

    assert_equal 3, partida.score_a
    assert_equal 3, partida.score_b
    assert_equal 2, partida.maos.count
    hand_one, hand_two = partida.maos.order(:numero).to_a
    assert_equal(-6, hand_one.pontos_b)
    assert_equal(-7, hand_two.pontos_a)
    assert_equal 1, hand_one.desconto_b
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
    assert_equal [ additional_duplas.first.name, @dupla_a.name ], [ round_two.partidas.first.dupla_a, round_two.partidas.first.dupla_b ]
  end
end
