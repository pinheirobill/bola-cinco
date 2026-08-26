class CreateMatchParticipations < ActiveRecord::Migration[8.1]
  def change
    create_table :match_participations do |t|
      t.string :source_id, null: false
      t.references :match, null: false, foreign_key: { on_delete: :cascade }
      t.references :team, null: false, foreign_key: { on_delete: :cascade }
      t.references :athlete, foreign_key: { on_delete: :nullify }
      t.string :athlete_name, null: false
      t.string :shirt_number
      t.string :position
      t.string :status, null: false, default: "confirmado"
      t.text :notes
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :match_participations, :source_id, unique: true
    add_index :match_participations, %i[match_id team_id athlete_id], unique: true, name: "index_match_participations_on_match_team_athlete"
    add_index :match_participations, %i[match_id status]
    add_index :match_participations, %i[team_id status]
  end
end
