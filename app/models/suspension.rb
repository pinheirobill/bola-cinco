class Suspension < ApplicationRecord
  belongs_to :championship
  belongs_to :category, optional: true
  belongs_to :team, optional: true
  belongs_to :athlete
  belongs_to :match_event, optional: true

  enum :status, {
    ativa: "ativa",
    cumprida: "cumprida",
    cancelada: "cancelada"
  }, prefix: true

  validates :source_id, :reason, presence: true
  validates :source_id, uniqueness: true

  def fulfill!
    update!(status: :cumprida)
  end

  def cancel!
    update!(status: :cancelada)
  end
end
