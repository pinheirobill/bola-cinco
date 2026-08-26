class User < ApplicationRecord
  audited

  THEMES = {
    "corporate" => {
      label: "Padrão",
      swatches: %w[#4c6fff #e5e7eb]
    },
    "flamengo" => {
      label: "Flamengo",
      swatches: %w[#c8102e #111111]
    },
    "palmeiras" => {
      label: "Palmeiras",
      swatches: %w[#007a33 #f5f7f2]
    },
    "corinthians" => {
      label: "Corinthians",
      swatches: %w[#111111 #f4f4f5]
    },
    "sao_paulo" => {
      label: "São Paulo",
      swatches: %w[#ffffff #c8102e]
    },
    "santos" => {
      label: "Santos",
      swatches: %w[#111111 #f5f5f5]
    },
    "gremio" => {
      label: "Grêmio",
      swatches: %w[#1d4ed8 #111827]
    },
    "cruzeiro" => {
      label: "Cruzeiro",
      swatches: %w[#2563eb #f8fafc]
    },
    "vasco" => {
      label: "Vasco",
      swatches: %w[#111111 #c8102e]
    },
    "fluminense" => {
      label: "Fluminense",
      swatches: %w[#006341 #7a1f2b]
    },
    "botafogo" => {
      label: "Botafogo",
      swatches: %w[#111111 #f5f5f5]
    },
    "internacional" => {
      label: "Internacional",
      swatches: %w[#d61f26 #ffffff]
    },
    "atletico_mg" => {
      label: "Atlético-MG",
      swatches: %w[#111111 #f5f5f5]
    },
    "bahia" => {
      label: "Bahia",
      swatches: %w[#0f62fe #d61f26]
    }
  }.freeze

  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :championship_memberships, dependent: :destroy
  has_many :championships, through: :championship_memberships
  has_one :athlete, dependent: :nullify

  attribute :role, :string

  enum :role, {
    adm_master: "adm_master",
    dono_da_quadra: "dono_da_quadra",
    tecnico_do_time: "tecnico_do_time",
    jogador_do_time: "jogador_do_time"
  }, default: :adm_master

  validates :preferred_theme, inclusion: { in: THEMES.keys }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
    adm_master? || dono_da_quadra?
  end

  def self.theme_options
    THEMES.map { |key, data| [data[:label], key] }
  end

  def self.theme_meta(theme_key)
    THEMES.fetch(theme_key.to_s, THEMES["corporate"])
  end

  def preferred_theme_meta
    self.class.theme_meta(preferred_theme)
  end

  def active_championship_memberships
    championship_memberships.includes(:championship).status_ativo
  end

  def accessible_championships
    admin? ? Championship.all : Championship.joins(:championship_memberships).merge(championship_memberships.status_ativo).distinct
  end

  def can_view_championship?(championship)
    admin? || accessible_championships.exists?(id: championship.id)
  end

  def can_manage_championship?(championship)
    return true if admin?

    championship_memberships.status_ativo.where(championship: championship).where(role: %w[organizador editor]).exists?
  end

  def active_team_memberships
    team_memberships.includes(:team).status_ativo
  end

  def accessible_teams
    Team.joins(:team_memberships)
      .merge(team_memberships.status_ativo)
      .distinct
  end

  def can_view_team?(team)
    admin? || accessible_teams.exists?(id: team.id)
  end

  def can_manage_team?(team)
    return true if admin?

    team_memberships
      .status_ativo
      .where(team: team)
      .where(role: %w[tecnico capitao responsavel])
      .exists?
  end

  def can_manage_athlete?(athlete)
    return true if admin?

    athlete.linked_teams.any? { |team| can_manage_team?(team) }
  end
end
