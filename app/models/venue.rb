class Venue < ApplicationRecord
  belongs_to :championship, optional: true
  has_many :matches, dependent: :nullify

  enum :status, {
    ativo: "ativo",
    inativo: "inativo"
  }, prefix: true

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true

  scope :available, -> { where(championship_id: nil) }
end
