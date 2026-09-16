require "test_helper"
require "open3"
require "tempfile"

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

  test "updates a tranca partida result through turbo stream without reloading the page" do
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
        score_a: 4,
        score_b: 2,
        status: "finalizado"
      }
    }, as: :turbo_stream

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, %(turbo-stream action="replace" target="flash-messages")
    assert_includes response.body, %(turbo-stream action="replace" target="tranca-partida-card-#{partida.id}")
    assert_includes response.body, "Resultado lançado."
    assert_includes response.body, "4 x 2"

    partida.reload
    assert_equal 4, partida.score_a
    assert_equal 2, partida.score_b
    assert_equal "finalizado", partida.status
  end

  test "updates tranca partida duplas through turbo stream without redirecting to rodadas" do
    dupla_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Luana / Carol"
    )
    dupla_d = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-d",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Rafa / Ju"
    )

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
        dupla_a_id: dupla_c.id,
        dupla_b_id: dupla_d.id
      }
    }, as: :turbo_stream

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, %(turbo-stream action="replace" target="flash-messages")
    assert_includes response.body, %(turbo-stream action="replace" target="tranca-partida-card-#{partida.id}")
    assert_includes response.body, "Duplas da partida atualizadas."
    assert_includes response.body, "Luana / Carol"
    assert_includes response.body, "Rafa / Ju"

    partida.reload
    assert_equal dupla_c.id, partida.dupla_a_id
    assert_equal dupla_d.id, partida.dupla_b_id
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
    assert_includes response.body, "Alterar dupla"

    document = Nokogiri::HTML(response.body)
    partida = Tranca::Partida.find_by!(source_id: "tranca-partida-#{@championship.id}-#{@category.id}-classificatoria-1-1")
    modal = document.at_css("#tranca-partida-modal-#{partida.id}")

    assert modal.present?
    assert_equal partida.dupla_a_id.to_s, modal.at_css(%(select[name="tranca_partida[dupla_a_id]"] option[selected]))["value"]
    assert_equal partida.dupla_b_id.to_s, modal.at_css(%(select[name="tranca_partida[dupla_b_id]"] option[selected]))["value"]
  end

  test "does not show desconto columns in the tranca summary editor" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    post generate_tranca_mesas_championship_path(@championship), params: {
      rodada_id: rodada.id
    }

    partida = rodada.partidas.first

    get edit_tranca_summula_championship_path(@championship, partida_id: partida.id)

    assert_response :success
    assert_includes response.body, "Pts A"
    assert_includes response.body, "Pts B"
    assert_not_includes response.body, "Desc. A"
    assert_not_includes response.body, "Desc. B"

    document = Nokogiri::HTML(response.body)
    hand_number_inputs = document.css('input[name^="tranca_partida[maos_attributes]"][name$="[numero]"]')
    assert_equal 5, hand_number_inputs.size
  end

  test "renders scheduled and finalized tranca summulas with five batidas" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    partida = rodada.partidas.first

    get download_tranca_summula_championship_path(@championship, partida_id: partida.id)

    assert_response :success
    assert_equal "application/pdf", response.media_type
    scheduled_text = extract_pdf_text(response.body)
    assert_includes scheduled_text, "5ª"
    assert_includes scheduled_text, "RESULTADO FINAL"
    assert_includes scheduled_text, "DUPLA VENCEDORA"

    patch update_tranca_partida_championship_path(@championship, partida_id: partida.id), params: {
      tranca_partida: {
        status: "finalizado",
        maos_attributes: {
          "0" => { numero: 1, pontos_a: 100, pontos_b: 50 },
          "1" => { numero: 2, pontos_a: 200, pontos_b: 100 },
          "2" => { numero: 3, pontos_a: 300, pontos_b: 150 },
          "3" => { numero: 4, pontos_a: 400, pontos_b: 200 },
          "4" => { numero: 5, pontos_a: 500, pontos_b: 250 }
        }
      }
    }

    get download_complete_tranca_summula_championship_path(@championship, partida_id: partida.id)

    assert_response :success
    assert_equal "application/pdf", response.media_type
    finalized_text = extract_pdf_text(response.body)
    assert_includes finalized_text, "5ª"
    assert_includes finalized_text, "1.500"
    assert_includes finalized_text, "750"
    assert_includes finalized_text, @dupla_a.name
  end

  test "shows the winner and edit summula link after a partida is finalized" do
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
        score_a: 4,
        score_b: 1,
        status: "finalizado"
      }
    }

    get rodadas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Vencedor:"
    assert_includes response.body, "ID do jogo: #{partida.id}"
    assert_includes response.body, "Editar súmula"
    assert_not_includes response.body, "Abrir súmula"
  end

  test "opens the edit summula page for a finalized partida" do
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
        score_a: 4,
        score_b: 1,
        status: "finalizado"
      }
    }

    get edit_tranca_summula_championship_path(@championship, partida_id: partida.id)

    assert_response :success
    assert_includes response.body, "Editar súmula"
    assert_includes response.body, "ID do jogo: #{partida.id}"
  end

  test "shows delete game action on scheduled rodada partidas" do
    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    get rodadas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Excluir jogo"
  end

  test "shows remove result action on finalized classificatoria partidas" do
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
      tranca_partida: { score_a: 4, score_b: 1, status: "finalizado" }
    }

    get rodadas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Remover resultado"
  end

  test "creates a new game inside an existing chave using existing duplas" do
    dupla_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Joana / Bruno"
    )

    dupla_d = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-d",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Maria / Luiz"
    )
    dupla_e = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-e",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Paula / Sérgio"
    )
    dupla_f = Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-f",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Lara / Diego"
    )

    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    rodada = Tranca::Rodada.find_by!(championship: @championship, phase: "classificatoria", round_number: 1)
    original_count = rodada.partidas.where(group_key: "A").count
    used_pairs = rodada.partidas.pluck(:dupla_a_id, :dupla_b_id).map { |dupla_a_id, dupla_b_id| [ dupla_a_id, dupla_b_id ].compact.sort }.to_set
    candidate_pair = [ @dupla_a, @dupla_b, dupla_c, dupla_d, dupla_e, dupla_f ].combination(2).find do |dupla_a, dupla_b|
      !used_pairs.include?([ dupla_a.id, dupla_b.id ].sort)
    end

    post create_tranca_partida_in_key_championship_path(@championship, rodada_id: rodada.id, group_key: "A"), params: {
      category_id: @category.id,
      dupla_a_id: candidate_pair.first.id,
      dupla_b_id: candidate_pair.last.id
    }

    assert_redirected_to rodadas_championship_path(@championship)
    rodada.reload

    created_partidas = rodada.partidas.where(group_key: "A").order(:id)
    assert_equal original_count + 1, created_partidas.count
    assert_equal [ candidate_pair.first.id, candidate_pair.last.id ].sort, [ created_partidas.last.dupla_a_id, created_partidas.last.dupla_b_id ].sort
    assert_equal "agendado", created_partidas.last.status
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

  test "removes the result of a finalized tranca partida without deleting the game" do
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
        score_a: 4,
        score_b: 1,
        status: "finalizado"
      }
    }

    assert_no_difference -> { @championship.tranca_classificacao_rows.count } do
      delete destroy_tranca_partida_championship_path(@championship, partida_id: partida.id)
    end

    assert_redirected_to rodadas_championship_path(@championship)
    partida.reload

    assert partida.status_agendado?
    assert_nil partida.score_a
    assert_nil partida.score_b
    assert_equal 0, partida.maos.count
    assert_equal [ 0, 0 ], @championship.tranca_classificacao_rows.where(category_id: @category.id).order(:position).pluck(:points)
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
    Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Luana / Carol"
    )
    Tranca::Dupla.create!(
      source_id: "dupla-tranca-workflow-d",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Rafa / Ju"
    )

    post generate_tranca_round_championship_path(@championship), params: {
      phase: "classificatoria",
      round_number: 1
    }

    row = @championship.tranca_classificacao_rows.order(:position).second

    delete destroy_tranca_classificacao_row_championship_path(@championship, row_id: row.id)

    assert_redirected_to classificacao_championship_path(@championship)
    assert_not Tranca::ClassificacaoRow.exists?(row.id)

    remaining_positions = @championship.tranca_classificacao_rows.where(category_id: @category.id, group_key: row.group_key).order(:position).pluck(:position)
    assert_equal [ 1, 2, 3 ], remaining_positions
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
            batida_b: "1"
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
            pontos_b: "-6"
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

  private

  def extract_pdf_text(pdf_data)
    Tempfile.create([ "tranca-summula", ".pdf" ]) do |file|
      file.binmode
      file.write(pdf_data)
      file.flush
      stdout, stderr, status = Open3.capture3("pdftotext", "-layout", file.path, "-")
      assert status.success?, stderr
      stdout
    end
  end
end
