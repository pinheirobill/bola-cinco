class Team < ApplicationRecord
  belongs_to :entity
  belongs_to :category
  has_many :athletes, dependent: :destroy
  has_many :home_matches, class_name: "Match", foreign_key: :team_a_id, dependent: :nullify, inverse_of: :team_a
  has_many :away_matches, class_name: "Match", foreign_key: :team_b_id, dependent: :nullify, inverse_of: :team_b
  has_many :winning_matches, class_name: "Match", foreign_key: :winner_id, dependent: :nullify, inverse_of: :winner
  has_many :standing_rows, dependent: :destroy

  enum :registration_status, {
    pendente: "pendente",
    aprovada: "aprovada",
    rejeitada: "rejeitada"
  }, prefix: true

  enum :finance_status, {
    pago: "pago",
    pendente: "pendente",
    atrasado: "atrasado"
  }, prefix: true

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true
end
