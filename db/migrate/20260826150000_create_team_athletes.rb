class CreateTeamAthletes < ActiveRecord::Migration[8.1]
  def change
    create_table :team_athletes do |t|
      t.string :source_id, null: false
      t.references :team, null: false, foreign_key: { on_delete: :cascade }
      t.references :athlete, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :team_athletes, :source_id, unique: true
    add_index :team_athletes, %i[team_id athlete_id], unique: true

    reversible do |dir|
      dir.up do
        say_with_time "Backfilling team athlete links" do
          Athlete.find_each do |athlete|
            next if athlete.team_id.blank?

            TeamAthlete.create!(
              source_id: "team-athlete-#{athlete.id}",
              team_id: athlete.team_id,
              athlete_id: athlete.id
            )
          end
        end
      end
    end
  end
end
