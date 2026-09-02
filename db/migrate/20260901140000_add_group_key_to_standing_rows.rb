class AddGroupKeyToStandingRows < ActiveRecord::Migration[8.1]
  def up
    add_column :standing_rows, :group_key, :string, null: false, default: ""

    remove_index :standing_rows, name: "index_standing_rows_on_competition_and_position"
    add_index :standing_rows, %i[championship_id category_id group_key position], unique: true, name: "index_standing_rows_on_competition_group_and_position"

    remove_index :standing_rows, name: "index_standing_rows_on_category_id_and_team_id"
    add_index :standing_rows, %i[category_id group_key team_id], unique: true, name: "index_standing_rows_on_category_group_and_team"
  end

  def down
    remove_index :standing_rows, name: "index_standing_rows_on_category_group_and_team"
    add_index :standing_rows, %i[category_id team_id], unique: true, name: "index_standing_rows_on_category_id_and_team_id"

    remove_index :standing_rows, name: "index_standing_rows_on_competition_group_and_position"
    add_index :standing_rows, %i[championship_id category_id position], unique: true, name: "index_standing_rows_on_competition_and_position"

    remove_column :standing_rows, :group_key
  end
end
