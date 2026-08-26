class MatchReport < ApplicationRecord
  belongs_to :match
  belongs_to :referee, optional: true

  enum :status, {
    rascunho: "rascunho",
    enviado: "enviado",
    aprovado: "aprovado",
    rejeitado: "rejeitado"
  }, prefix: true

  validates :source_id, presence: true, uniqueness: true
end
