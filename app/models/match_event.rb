class MatchEvent < ApplicationRecord
  belongs_to :championship
  belongs_to :match, optional: true
  belongs_to :team, optional: true
  belongs_to :athlete, optional: true

  before_validation :sync_championship_from_match

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

  private

  def sync_championship_from_match
    self.championship ||= match&.championship
  end
end
