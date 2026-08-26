class Team < ApplicationRecord
  belongs_to :entity
  belongs_to :category
  has_many :team_athletes, dependent: :delete_all
  has_many :athletes, through: :team_athletes
  has_many :match_events, dependent: :nullify
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :home_matches, class_name: "Match", foreign_key: :team_a_id, dependent: :nullify, inverse_of: :team_a
  has_many :away_matches, class_name: "Match", foreign_key: :team_b_id, dependent: :nullify, inverse_of: :team_b
  has_many :winning_matches, class_name: "Match", foreign_key: :winner_id, dependent: :nullify, inverse_of: :winner
  has_many :standing_rows, dependent: :destroy

  enum :registration_status, {
    pendente: "pendente",
    aprovada: "aprovada",
    rejeitada: "rejeitada"
  }, prefix: true

  enum :finance_status, {
    pago: "pago",
    pendente: "pendente",
    atrasado: "atrasado"
  }, prefix: true

  scope :for_championship, ->(championship) { joins(category: :championships).where(championships: { id: championship.is_a?(Championship) ? championship.id : championship }).distinct }

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true

  def approve!
    update!(registration_status: :aprovada)
  end

  def reject!
    update!(registration_status: :rejeitada)
  end

  def manageable_by?(user)
    user&.can_manage_team?(self)
  end

  def visible_by?(user)
    user&.can_view_team?(self)
  end

  def picker_label
    "#{name} · #{category.name}"
  end

  def signup_picker_label
    [
      name,
      entity&.name,
      category&.name
    ].compact.join(" · ")
  end

  def championship
    category&.championship || category&.championships&.first
  end
end
