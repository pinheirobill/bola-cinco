module Tranca
  class PartidaMao < ApplicationRecord
    self.table_name = "tranca_partida_maos"

    belongs_to :championship
    belongs_to :partida, class_name: "Tranca::Partida", foreign_key: :tranca_partida_id, inverse_of: :maos

    validates :source_id, presence: true, uniqueness: true
    validates :numero, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :pontos_a, :pontos_b, numericality: { only_integer: true }
    validates :desconto_a, :desconto_b, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    def score_a
      pontos_a.to_i
    end

    def score_b
      pontos_b.to_i
    end

    def resumo
      ["Mão #{numero}", "A: #{pontos_a}", "B: #{pontos_b}"].join(" · ")
    end
  end
end
