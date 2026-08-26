class MatchParticipation < ApplicationRecord
  belongs_to :match
  belongs_to :team
  belongs_to :athlete, optional: true

  enum :status, {
    pendente: "pendente",
    confirmado: "confirmado",
    ausente: "ausente",
    convidado: "convidado"
  }, prefix: true

  validates :source_id, :team_id, :athlete_name, :status, presence: true
  validates :source_id, uniqueness: true
  validates :athlete_id, uniqueness: { scope: %i[match_id team_id], allow_nil: true }
  validates :athlete_name, presence: true, unless: -> { athlete_id.present? }

  before_validation :sync_snapshot_fields, on: :create

  private

  def sync_snapshot_fields
    return unless athlete.present?

    self.athlete_name ||= athlete.name
    self.shirt_number ||= athlete.shirt_number
    self.position ||= athlete.position
  end
end
