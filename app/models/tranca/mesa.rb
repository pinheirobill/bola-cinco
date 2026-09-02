module Tranca
  class Mesa < ApplicationRecord
    self.table_name = "tranca_mesas"

    belongs_to :championship
    belongs_to :tranca_rodada, class_name: "Tranca::Rodada", optional: true
    has_many :partidas, class_name: "Tranca::Partida", foreign_key: :tranca_mesa_id, dependent: :nullify, inverse_of: :tranca_mesa

    validates :source_id, presence: true, uniqueness: true
    validates :code, :name, presence: true
  end
end
