class AddVenueToMatches < ActiveRecord::Migration[8.1]
  def change
    add_reference :matches, :venue, foreign_key: true
  end
end
