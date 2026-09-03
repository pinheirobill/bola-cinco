class AddStatusToTrancaDuplas < ActiveRecord::Migration[7.1]
  def change
    add_column :tranca_duplas, :status, :string, null: false, default: "ativo"
    add_index :tranca_duplas, :status
  end
end
