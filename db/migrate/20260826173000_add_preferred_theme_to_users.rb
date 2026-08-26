class AddPreferredThemeToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :preferred_theme, :string, null: false, default: "corporate"
    add_index :users, :preferred_theme
  end
end
