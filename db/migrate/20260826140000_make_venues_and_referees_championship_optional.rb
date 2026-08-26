class MakeVenuesAndRefereesChampionshipOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :venues, :championship_id, true
    change_column_null :referees, :championship_id, true
  end
end
