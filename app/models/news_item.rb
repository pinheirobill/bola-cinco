class NewsItem < ApplicationRecord
  belongs_to :championship
  belongs_to :category, optional: true

  enum :status, {
    rascunho: "rascunho",
    publicada: "publicada",
    arquivada: "arquivada"
  }, prefix: true

  validates :source_id, :title, presence: true
  validates :source_id, uniqueness: true
end
