class CreateTrancaPartidaMaos < ActiveRecord::Migration[8.1]
  def change
    create_table :tranca_partida_maos do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :tranca_partida, null: false, foreign_key: true
      t.string :source_id, null: false
      t.integer :numero, null: false
      t.integer :pontos_a, null: false, default: 0
      t.integer :pontos_b, null: false, default: 0
      t.boolean :canastra_limpa_a, null: false, default: false
      t.boolean :canastra_limpa_b, null: false, default: false
      t.boolean :canastra_suja_a, null: false, default: false
      t.boolean :canastra_suja_b, null: false, default: false
      t.boolean :batida_a, null: false, default: false
      t.boolean :batida_b, null: false, default: false
      t.boolean :tres_vermelho_a, null: false, default: false
      t.boolean :tres_vermelho_b, null: false, default: false
      t.integer :desconto_a, null: false, default: 0
      t.integer :desconto_b, null: false, default: 0
      t.text :observacoes
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :tranca_partida_maos, :source_id, unique: true
    add_index :tranca_partida_maos, %i[tranca_partida_id numero], unique: true, name: "index_tranca_partida_maos_on_partida_and_numero"
    add_index :tranca_partida_maos, %i[championship_id tranca_partida_id], name: "index_tranca_partida_maos_on_scope"
  end
end
