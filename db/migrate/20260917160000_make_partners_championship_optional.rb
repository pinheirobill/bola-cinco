class MakePartnersChampionshipOptional < ActiveRecord::Migration[8.0]
  def change
    change_column_null :partners, :championship_id, true
  end
end
