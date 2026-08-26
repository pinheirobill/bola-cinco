class CreateMatchReportsSuspensionsRoundSelections < ActiveRecord::Migration[8.1]
  def change
    create_table :match_reports do |t|
      t.string :source_id, null: false
      t.references :match, null: false, foreign_key: true, index: { unique: true }
      t.references :referee, foreign_key: true
      t.string :status, null: false, default: "rascunho"
      t.datetime :submitted_at
      t.datetime :approved_at
      t.text :notes
      t.string :sheet_url
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :match_reports, :source_id, unique: true
    add_index :match_reports, %i[status submitted_at]

    create_table :suspensions do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.references :team, foreign_key: true
      t.references :athlete, null: false, foreign_key: true
      t.references :match_event, foreign_key: true
      t.string :reason, null: false
      t.string :status, null: false, default: "ativa"
      t.boolean :automatic, null: false, default: false
      t.integer :matches_count, null: false, default: 1
      t.date :starts_on
      t.date :ends_on
      t.text :notes
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :suspensions, :source_id, unique: true
    add_index :suspensions, %i[athlete_id status]
    add_index :suspensions, %i[championship_id category_id status]

    create_table :round_selections do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.integer :round_number, null: false
      t.string :title, null: false
      t.text :notes
      t.datetime :published_at
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :round_selections, :source_id, unique: true
    add_index :round_selections, %i[championship_id category_id round_number], unique: true, name: "index_round_selections_on_scope_and_round"

    create_table :round_selection_athletes do |t|
      t.references :round_selection, null: false, foreign_key: true
      t.references :athlete, null: false, foreign_key: true
      t.integer :position
      t.timestamps
    end

    add_index :round_selection_athletes, %i[round_selection_id athlete_id], unique: true
  end
end
