class AddModalityToChampionships < ActiveRecord::Migration[8.1]
  def up
    add_column :championships, :modality, :string, null: false, default: "football"
    add_index :championships, :modality
  end

  def down
    remove_index :championships, :modality
    remove_column :championships, :modality
  end
end
