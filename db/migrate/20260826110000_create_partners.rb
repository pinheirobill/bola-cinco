class CreatePartners < ActiveRecord::Migration[8.1]
  def change
    create_table :partners do |t|
      t.string :source_id, null: false
      t.references :championship, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.string :name, null: false
      t.string :tier, null: false, default: "parceiro"
      t.string :status, null: false, default: "ativo"
      t.string :logo_url
      t.string :website_url
      t.boolean :highlight, null: false, default: false
      t.text :notes
      t.json :source_data, null: false, default: {}
      t.timestamps
    end

    add_index :partners, :source_id, unique: true
    add_index :partners, %i[championship_id status highlight]
    add_index :partners, %i[championship_id tier]
  end
end
