class CreateChampionshipMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :championship_memberships do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false, default: "organizador"
      t.string :status, null: false, default: "ativo"
      t.text :notes
      t.timestamps
    end

    add_index :championship_memberships, :source_id, unique: true
    add_index :championship_memberships, %i[championship_id user_id], unique: true
    add_index :championship_memberships, %i[user_id status]
  end
end
