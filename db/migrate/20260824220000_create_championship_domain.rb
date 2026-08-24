class CreateChampionshipDomain < ActiveRecord::Migration[8.1]
  def change
    create_table :championships do |t|
      t.string :source_id, null: false
      t.string :name, null: false
      t.integer :season, null: false
      t.date :start_date
      t.date :end_date
      t.date :registration_start
      t.date :registration_end
      t.string :status, null: false, default: "rascunho"
      t.json :rules, null: false, default: {}
      t.json :scoring, null: false, default: {}
      t.json :format, null: false, default: {}
      t.text :notes
      t.timestamps
    end

    add_index :championships, :source_id, unique: true
    add_index :championships, :season
    add_index :championships, :status

    create_table :categories do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.string :name, null: false
      t.string :gender
      t.integer :min_birth_year
      t.integer :max_birth_year
      t.integer :max_athletes
      t.integer :position
      t.timestamps
    end

    add_index :categories, :source_id, unique: true
    add_index :categories, %i[championship_id position]

    create_table :entities do |t|
      t.string :source_id, null: false
      t.string :name, null: false
      t.string :responsible
      t.string :phone
      t.string :whatsapp
      t.string :email
      t.string :city
      t.text :notes
      t.timestamps
    end

    add_index :entities, :source_id, unique: true
    add_index :entities, :name

    create_table :teams do |t|
      t.string :source_id, null: false
      t.references :entity, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.string :short_name
      t.string :registration_status, null: false, default: "pendente"
      t.string :finance_status, null: false, default: "pendente"
      t.string :group_key
      t.timestamps
    end

    add_index :teams, :source_id, unique: true
    add_index :teams, %i[category_id group_key]
    add_index :teams, %i[entity_id category_id]

    create_table :athletes do |t|
      t.string :source_id, null: false
      t.references :team, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.date :birth_date
      t.string :shirt_number
      t.string :document
      t.string :status, null: false, default: "pendente"
      t.timestamps
    end

    add_index :athletes, :source_id, unique: true
    add_index :athletes, %i[team_id status]

    create_table :matches do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :code, null: false
      t.string :phase, null: false
      t.string :group_key
      t.integer :round_number
      t.date :scheduled_on
      t.string :scheduled_time
      t.string :venue
      t.references :team_a, foreign_key: { to_table: :teams }
      t.references :team_b, foreign_key: { to_table: :teams }
      t.json :source_a
      t.json :source_b
      t.integer :score_a
      t.integer :score_b
      t.string :status, null: false, default: "agendado"
      t.string :wo
      t.references :winner, foreign_key: { to_table: :teams }
      t.integer :penalties_a
      t.integer :penalties_b
      t.string :decision
      t.json :scorers, null: false, default: {}
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :matches, :source_id, unique: true
    add_index :matches, %i[category_id phase group_key]
    add_index :matches, %i[championship_id scheduled_on]
    add_index :matches, :code

    create_table :standing_rows do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :position, null: false
      t.integer :played, null: false, default: 0
      t.integer :wins, null: false, default: 0
      t.integer :draws, null: false, default: 0
      t.integer :losses, null: false, default: 0
      t.integer :goals_for, null: false, default: 0
      t.integer :goals_against, null: false, default: 0
      t.integer :goal_diff, null: false, default: 0
      t.integer :points, null: false, default: 0
      t.boolean :qualified
      t.timestamps
    end

    add_index :standing_rows, %i[championship_id category_id position], unique: true, name: "index_standing_rows_on_competition_and_position"
    add_index :standing_rows, %i[category_id team_id], unique: true

    create_table :invoices do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :championship, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false, default: 0
      t.date :due_date
      t.string :status, null: false, default: "pendente"
      t.timestamps
    end

    add_index :invoices, %i[entity_id status]
    add_index :invoices, %i[championship_id category_id]
  end
end
