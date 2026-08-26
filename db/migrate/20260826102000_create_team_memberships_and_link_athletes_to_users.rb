class CreateTeamMembershipsAndLinkAthletesToUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :team_memberships do |t|
      t.string :source_id, null: false
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false, default: "tecnico"
      t.string :status, null: false, default: "ativo"
      t.text :notes
      t.timestamps
    end

    add_index :team_memberships, :source_id, unique: true
    add_index :team_memberships, %i[team_id user_id], unique: true
    add_index :team_memberships, %i[user_id status]

    add_reference :athletes, :user, foreign_key: true, index: { unique: true }
    add_index :athletes, %i[team_id user_id], unique: true
  end
end
