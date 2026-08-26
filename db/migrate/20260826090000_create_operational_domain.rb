class CreateOperationalDomain < ActiveRecord::Migration[8.1]
  def change
    create_table :venues do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.string :name, null: false
      t.string :short_name
      t.string :city
      t.string :address
      t.text :notes
      t.string :status, null: false, default: "ativo"
      t.timestamps
    end

    add_index :venues, :source_id, unique: true
    add_index :venues, %i[championship_id status]

    create_table :referees do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.string :name, null: false
      t.string :document
      t.string :phone
      t.string :email
      t.text :notes
      t.string :status, null: false, default: "ativo"
      t.timestamps
    end

    add_index :referees, :source_id, unique: true
    add_index :referees, %i[championship_id status]

    create_table :match_events do |t|
      t.string :source_id, null: false
      t.references :match, null: false, foreign_key: true
      t.references :team, foreign_key: { on_delete: :nullify }
      t.references :athlete, foreign_key: { on_delete: :nullify }
      t.string :kind, null: false
      t.integer :minute
      t.string :period
      t.text :notes
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :match_events, :source_id, unique: true
    add_index :match_events, %i[match_id kind]
    add_index :match_events, %i[athlete_id kind]

    create_table :news_items do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.datetime :published_at
      t.boolean :pinned, null: false, default: false
      t.string :status, null: false, default: "rascunho"
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :news_items, :source_id, unique: true
    add_index :news_items, %i[championship_id status published_at]
  end
end
