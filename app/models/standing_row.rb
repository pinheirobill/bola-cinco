class StandingRow < ApplicationRecord
  belongs_to :championship
  belongs_to :category
  belongs_to :team

  validates :position, presence: true
end
