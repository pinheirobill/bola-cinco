class AddRegistrationFieldsToAthletes < ActiveRecord::Migration[8.1]
  def change
    change_table :athletes, bulk: true do |t|
      t.string :photo_url
      t.string :cpf
      t.string :rg
      t.string :birth_certificate
      t.string :position
      t.string :cell_phone
      t.string :email
      t.string :passport
      t.string :voter_id
      t.string :gender
      t.integer :documents_count, null: false, default: 0
      t.datetime :registration_submitted_at
    end
  end
end
