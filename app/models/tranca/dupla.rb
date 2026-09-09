module Tranca
  class Dupla < ApplicationRecord
    self.table_name = "tranca_duplas"

    belongs_to :championship
    belongs_to :category
    belongs_to :entity, optional: true
    has_many :memberships, class_name: "Tranca::DuplaMembership", dependent: :destroy, inverse_of: :tranca_dupla
    has_many :athletes, through: :memberships
    has_many :classificacao_rows, class_name: "Tranca::ClassificacaoRow", foreign_key: :tranca_dupla_id, dependent: :destroy
    has_many :partidas_as_a, class_name: "Tranca::Partida", foreign_key: :dupla_a_id, dependent: :nullify, inverse_of: :dupla_a
    has_many :partidas_as_b, class_name: "Tranca::Partida", foreign_key: :dupla_b_id, dependent: :nullify, inverse_of: :dupla_b
    has_many :winning_partidas, class_name: "Tranca::Partida", foreign_key: :winner_id, dependent: :nullify, inverse_of: :winner

    enum :status, {
      ativo: "ativo",
      inativo: "inativo"
    }, prefix: true

    validates :source_id, presence: true, uniqueness: true
    validates :name, presence: true

    def integrantes
      athletes
    end

    def integrante_names
      athletes.map(&:name)
    end

    def legacy_team
      Team.find_by(source_id: source_id)
    end

    def legacy_team_id
      legacy_team&.id
    end
  end
end
