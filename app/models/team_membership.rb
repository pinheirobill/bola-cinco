class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :user

  enum :role, {
    tecnico: "tecnico",
    capitao: "capitao",
    atleta: "atleta",
    responsavel: "responsavel"
  }, prefix: true

  enum :status, {
    ativo: "ativo",
    inativo: "inativo"
  }, prefix: true

  validates :source_id, presence: true, uniqueness: true
  validates :team_id, uniqueness: { scope: :user_id }

  scope :manager_roles, -> { where(role: %w[tecnico capitao responsavel]) }

  def manager_role?
    role_tecnico? || role_capitao? || role_responsavel?
  end
end
