class Athlete < ApplicationRecord
  belongs_to :team
  belongs_to :category

  enum :status, {
    pendente: "pendente",
    validado: "validado",
    bloqueado: "bloqueado"
  }, prefix: true

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true
end
