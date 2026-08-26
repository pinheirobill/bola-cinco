class ChampionshipCategory < ApplicationRecord
  belongs_to :championship
  belongs_to :category

  validates :source_id, presence: true, uniqueness: true
  validates :category_id, uniqueness: { scope: :championship_id }
end
