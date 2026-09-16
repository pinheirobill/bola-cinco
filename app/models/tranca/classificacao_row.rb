module Tranca
  class ClassificacaoRow < ApplicationRecord
    self.table_name = "tranca_classificacao_rows"

    belongs_to :championship
    belongs_to :category
    belongs_to :tranca_dupla, class_name: "Tranca::Dupla"

    validates :source_id, presence: true, uniqueness: true
    validates :position, presence: true
    validates :stage_number, numericality: { only_integer: true, greater_than: 0 }

    scope :for_stage, ->(stage_number) { where(stage_number: stage_number) }

    def first_stage?
      stage_number == 1
    end

    def second_stage?
      stage_number == 2
    end

    def stage_label
      "#{stage_number}ª etapa"
    end

    def dupla
      tranca_dupla&.name
    end

    def posicao
      position
    end

    def display_team
      tranca_dupla
    end

    def display_team_name
      tranca_dupla&.name
    end

    def legacy_team
      tranca_dupla&.legacy_team
    end

    def team
      legacy_team
    end

    def team_id
      legacy_team&.id
    end

    def dupla_nome
      dupla
    end

    def pontos
      points
    end
  end
end
