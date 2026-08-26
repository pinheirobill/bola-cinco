class User < ApplicationRecord
  audited

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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
    adm_master? || dono_da_quadra?
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
