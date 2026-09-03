class AddPublicSignupVisitsCountToChampionships < ActiveRecord::Migration[8.1]
  def change
    add_column :championships, :public_signup_visits_count, :integer, null: false, default: 0
  end
end
