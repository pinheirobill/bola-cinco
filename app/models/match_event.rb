class MatchEvent < ApplicationRecord
  belongs_to :match
  belongs_to :team, optional: true
  belongs_to :athlete, optional: true

  enum :kind, {
    gol: "gol",
    assistencia: "assistencia",
    cartao_amarelo: "cartao_amarelo",
    cartao_vermelho: "cartao_vermelho",
    substituicao: "substituicao",
    outro: "outro"
  }, prefix: true

  validates :source_id, :kind, presence: true
  validates :source_id, uniqueness: true
end
