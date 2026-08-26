class CreateChampionshipCategories < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:championship_categories)

    create_table :championship_categories do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :source_id, null: false
      t.timestamps
    end

    add_index :championship_categories, :source_id, unique: true
    add_index :championship_categories, %i[championship_id category_id], unique: true, name: "index_championship_categories_on_championship_and_category"
  end
end
