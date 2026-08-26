class ChampionshipMembership < ApplicationRecord
  belongs_to :championship
  belongs_to :user

  enum :role, {
    organizador: "organizador",
    editor: "editor",
    leitor: "leitor"
  }, prefix: true

  enum :status, {
    ativo: "ativo",
    inativo: "inativo"
  }, prefix: true

  validates :source_id, presence: true, uniqueness: true
  validates :championship_id, uniqueness: { scope: :user_id }

  def editor_role?
    role_organizador? || role_editor?
  end
end
