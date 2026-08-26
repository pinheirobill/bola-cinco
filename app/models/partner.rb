class Partner < ApplicationRecord
  belongs_to :championship
  belongs_to :category, optional: true

  enum :tier, {
    patrocinador: "patrocinador",
    parceiro: "parceiro",
    apoiador: "apoiador"
  }, prefix: true

  enum :status, {
    ativo: "ativo",
    inativo: "inativo"
  }, prefix: true

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true
end
