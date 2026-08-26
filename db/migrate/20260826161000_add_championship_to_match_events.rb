class AddChampionshipToMatchEvents < ActiveRecord::Migration[8.1]
  def up
    add_reference :match_events, :championship, null: true, foreign_key: true

    execute <<~SQL.squish
      UPDATE match_events
      SET championship_id = matches.championship_id
      FROM matches
      WHERE match_events.match_id = matches.id
    SQL

    change_column_null :match_events, :championship_id, false
    change_column_null :match_events, :match_id, true
  end

  def down
    change_column_null :match_events, :match_id, false
    remove_reference :match_events, :championship, foreign_key: true
  end
end
