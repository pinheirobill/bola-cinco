class TeamAthlete < ApplicationRecord
  belongs_to :team
  belongs_to :athlete

  validates :source_id, :team_id, :athlete_id, presence: true
  validates :source_id, uniqueness: true
  validates :athlete_id, uniqueness: { scope: :team_id }
end
