class StandingRow < ApplicationRecord
  belongs_to :championship
  belongs_to :category
  belongs_to :team

  validates :position, presence: true

  def group_label
    group_key.present? ? "Chave #{group_key}" : "Geral"
  end
end
