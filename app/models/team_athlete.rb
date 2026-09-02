class TeamAthlete < ApplicationRecord
  belongs_to :team
  belongs_to :athlete
  after_commit :sync_tranca_mirror!, on: %i[create update destroy]

  validates :source_id, :team_id, :athlete_id, presence: true
  validates :source_id, uniqueness: true
  validates :athlete_id, uniqueness: { scope: :team_id }

  private

  def sync_tranca_mirror!
    return unless team&.championship&.tranca?

    if destroyed?
      Tranca::DuplaMembership.find_by(source_id: source_id)&.destroy!
      return
    end

    tranca_dupla = Tranca::Dupla.find_by(source_id: team.source_id)
    return if tranca_dupla.blank?

    membership = Tranca::DuplaMembership.find_or_initialize_by(source_id: source_id)
    membership.assign_attributes(
      tranca_dupla: tranca_dupla,
      athlete: athlete
    )
    membership.save!
  end
end
