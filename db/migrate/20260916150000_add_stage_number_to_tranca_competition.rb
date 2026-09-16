class AddStageNumberToTrancaCompetition < ActiveRecord::Migration[8.1]
  def up
    add_column :tranca_rodadas, :stage_number, :integer, null: false, default: 1
    add_column :tranca_partidas, :stage_number, :integer, null: false, default: 1
    add_column :tranca_classificacao_rows, :stage_number, :integer, null: false, default: 1

    remove_index :tranca_rodadas, name: "index_tranca_rodadas_on_scope_and_round"
    add_index :tranca_rodadas,
      %i[championship_id stage_number phase round_number],
      unique: true,
      name: "index_tranca_rodadas_on_stage_scope_and_round"

    remove_index :tranca_partidas, name: "index_tranca_partidas_on_scope_phase_round"
    add_index :tranca_partidas,
      %i[championship_id stage_number phase round_number],
      name: "index_tranca_partidas_on_stage_scope_phase_round"

    remove_index :tranca_classificacao_rows, name: "index_tranca_classificacao_rows_on_group_and_dupla"
    remove_index :tranca_classificacao_rows, name: "index_tranca_classificacao_rows_on_scope_and_position"
    add_index :tranca_classificacao_rows,
      %i[category_id stage_number group_key tranca_dupla_id],
      unique: true,
      name: "index_tranca_class_rows_on_stage_group_and_dupla"
    add_index :tranca_classificacao_rows,
      %i[championship_id category_id stage_number group_key position],
      unique: true,
      name: "index_tranca_class_rows_on_stage_scope_position"
  end

  def down
    remove_index :tranca_classificacao_rows, name: "index_tranca_class_rows_on_stage_scope_position"
    remove_index :tranca_classificacao_rows, name: "index_tranca_class_rows_on_stage_group_and_dupla"
    add_index :tranca_classificacao_rows,
      %i[championship_id category_id group_key position],
      unique: true,
      name: "index_tranca_classificacao_rows_on_scope_and_position"
    add_index :tranca_classificacao_rows,
      %i[category_id group_key tranca_dupla_id],
      unique: true,
      name: "index_tranca_classificacao_rows_on_group_and_dupla"

    remove_index :tranca_partidas, name: "index_tranca_partidas_on_stage_scope_phase_round"
    add_index :tranca_partidas,
      %i[championship_id phase round_number],
      name: "index_tranca_partidas_on_scope_phase_round"

    remove_index :tranca_rodadas, name: "index_tranca_rodadas_on_stage_scope_and_round"
    add_index :tranca_rodadas,
      %i[championship_id phase round_number],
      unique: true,
      name: "index_tranca_rodadas_on_scope_and_round"

    remove_column :tranca_classificacao_rows, :stage_number
    remove_column :tranca_partidas, :stage_number
    remove_column :tranca_rodadas, :stage_number
  end
end
