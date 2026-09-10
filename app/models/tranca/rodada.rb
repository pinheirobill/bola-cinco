module Tranca
  class Rodada < ApplicationRecord
    self.table_name = "tranca_rodadas"

    belongs_to :championship
    has_many :mesas, class_name: "Tranca::Mesa", foreign_key: :tranca_rodada_id, dependent: :nullify, inverse_of: :tranca_rodada
    has_many :partidas, class_name: "Tranca::Partida", foreign_key: :tranca_rodada_id, dependent: :nullify, inverse_of: :tranca_rodada

    validates :source_id, presence: true, uniqueness: true
    validates :phase, :round_number, :label, presence: true

    def classificatoria?
      phase.to_s.start_with?("classific")
    end

    def mata_mata?
      phase.to_s == "mata_mata"
    end

    def phase_label
      case phase.to_s
      when "classificatoria" then "Classificatória"
      when "mata_mata" then "Mata-mata"
      else phase.to_s.tr("_", " ").humanize
      end
    end

    def deletable?
      !partidas.where(status: %w[finalizado wo]).exists?
    end
  end
end
