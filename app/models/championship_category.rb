class ChampionshipCategory < ApplicationRecord
  belongs_to :championship
  belongs_to :category

  before_validation :assign_source_id, on: :create

  validates :source_id, presence: true, uniqueness: true
  validates :category_id, uniqueness: { scope: :championship_id }

  private

  def assign_source_id
    self.source_id ||= "championship-category-#{championship_id}-#{category_id || category&.id || SecureRandom.hex(4)}"
  end
end
