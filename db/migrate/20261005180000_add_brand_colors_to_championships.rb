class AddBrandColorsToChampionships < ActiveRecord::Migration[8.0]
  def change
    add_column :championships, :primary_color, :string
    add_column :championships, :secondary_color, :string
  end
end
