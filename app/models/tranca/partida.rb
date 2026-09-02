module Tranca
  class Partida < ApplicationRecord
    self.table_name = "tranca_partidas"

    belongs_to :championship
    belongs_to :category
    belongs_to :tranca_rodada, class_name: "Tranca::Rodada", optional: true
    belongs_to :tranca_mesa, class_name: "Tranca::Mesa", optional: true
    belongs_to :dupla_a, class_name: "Tranca::Dupla", optional: true
    belongs_to :dupla_b, class_name: "Tranca::Dupla", optional: true
    belongs_to :winner, class_name: "Tranca::Dupla", optional: true
    has_many :maos, class_name: "Tranca::PartidaMao", foreign_key: :tranca_partida_id, dependent: :destroy, inverse_of: :partida

    enum :status, {
      agendado: "agendado",
      em_andamento: "em_andamento",
      finalizado: "finalizado",
      wo: "wo",
      cancelado: "cancelado"
    }, prefix: true

    enum :decision, {
      normal: "normal",
      gol_de_ouro: "gol_de_ouro",
      penaltis: "penaltis"
    }, prefix: true, allow_nil: true

    validates :source_id, presence: true, uniqueness: true
    validates :code, :phase, presence: true

    def mesa
      tranca_mesa&.name.presence || "Mesa #{code}"
    end

    def team_a
      association(:dupla_a).reader
    end

    def team_b
      association(:dupla_b).reader
    end

    def dupla_a
      association(:dupla_a).reader&.name
    end

    def dupla_a_nome
      association(:dupla_a).reader&.name
    end

    def dupla_b
      association(:dupla_b).reader&.name
    end

    def dupla_b_nome
      association(:dupla_b).reader&.name
    end

    def pontos_a
      maos.any? ? maos.sum(:pontos_a).to_i : score_a
    end

    def pontos_b
      maos.any? ? maos.sum(:pontos_b).to_i : score_b
    end

    def score_a
      maos.any? ? maos.sum(:pontos_a).to_i : self[:score_a]
    end

    def score_b
      maos.any? ? maos.sum(:pontos_b).to_i : self[:score_b]
    end

    def venue_name
      tranca_mesa&.name.presence || "Mesa #{code}"
    end

    def legacy_match
      Match.find_by(source_id: source_id)
    end

    def legacy_match_id
      legacy_match&.id
    end

    def live?
      status_em_andamento?
    end

    def finished?
      status_finalizado? || status_wo?
    end

    def upcoming?
      status_agendado?
    end

    def classification_phase?
      phase.to_s.start_with?("classific")
    end

    def knockout_phase?
      phase.to_s == "mata_mata"
    end

    def phase_label
      case phase.to_s
      when "classificatoria" then "Classificatória"
      when "mata_mata" then "Mata-mata"
      else phase.to_s.tr("_", " ").humanize
      end
    end

    def clear_hand_scores!
      update_columns(
        score_a: maos.sum(:pontos_a).to_i,
        score_b: maos.sum(:pontos_b).to_i,
        updated_at: Time.current
      )
    end
  end
end
