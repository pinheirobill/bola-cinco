class CreateChampionshipCategories < ActiveRecord::Migration[8.1]
  def up
    create_table :championship_categories do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end

    add_index :championship_categories, :source_id, unique: true
    add_index :championship_categories, %i[championship_id category_id], unique: true, name: "index_championship_categories_on_championship_and_category"

    change_column_null :categories, :championship_id, true
    remove_foreign_key :categories, :championships
    add_foreign_key :categories, :championships, on_delete: :nullify

    Category.find_each do |category|
      next if category.championship_id.blank?

      ChampionshipCategory.find_or_create_by!(championship_id: category.championship_id, category_id: category.id) do |membership|
        membership.source_id = "championship-category-#{category.championship_id}-#{category.id}"
      end
    end
  end

  def down
    remove_foreign_key :categories, :championships
    drop_table :championship_categories
    change_column_null :categories, :championship_id, false
    add_foreign_key :categories, :championships
  end
end
