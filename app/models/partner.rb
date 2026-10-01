class Partner < ApplicationRecord
  belongs_to :championship, optional: true
  belongs_to :category, optional: true
  has_one_attached :logo

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

  def display_logo_url
    return Rails.application.routes.url_helpers.rails_blob_path(logo, only_path: true) if logo.attached?

    logo_url
  end
end
