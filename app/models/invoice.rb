class Invoice < ApplicationRecord
  belongs_to :entity
  belongs_to :championship
  belongs_to :category, optional: true

  enum :status, {
    pago: "pago",
    pendente: "pendente",
    atrasado: "atrasado"
  }, prefix: true

  validates :amount, presence: true
end
