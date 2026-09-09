class Athlete < ApplicationRecord
  attr_accessor :primary_team_link_imported

  belongs_to :team
  belongs_to :category
  belongs_to :user, optional: true
  has_many :team_athletes, dependent: :delete_all
  has_many :linked_teams, through: :team_athletes, source: :team
  has_many :match_events, dependent: :nullify
  has_many :match_participations, dependent: :delete_all
  has_many :suspensions, dependent: :destroy

  after_commit :sync_primary_team_link, on: %i[create update]

  scope :for_picker, -> { unscoped.includes(:team, :category, :linked_teams).order(:name) }

  enum :status, {
    pendente: "pendente",
    validado: "validado",
    bloqueado: "bloqueado"
  }, prefix: true

  scope :for_championship, ->(championship) { joins(category: :championships).where(championships: { id: championship.is_a?(Championship) ? championship.id : championship }).distinct }
  scope :ativos, -> { status_validado }

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true

  def display_photo_url
    return if photo_url.blank?
    return if photo_url == "placeholder.webp"
    return photo_url if photo_url.match?(%r{\Ahttps?://}i) || photo_url.start_with?("//", "/")

    asset_paths = Rails.application.config.assets.paths
    return photo_url if asset_paths.any? { |path| File.exist?(File.join(path, photo_url)) }

    nil
  end

  def preferred_document
    cpf.presence || document.presence
  end

  def initials
    name.to_s.split.map(&:first).first(2).join.upcase
  end

  def quick_label
    name.to_s.split.first(2).join(" ")
  end

  def match_roster_label
    [
      shirt_number.presence,
      quick_label.presence || name,
      team&.name
    ].compact.join(" · ")
  end

  def shirt_number_sort_key
    raw = shirt_number.to_s.strip
    return [1, 0, ""] if raw.blank?

    digits = raw.gsub(/\D/, "")
    digits.present? ? [0, digits.to_i, raw.downcase] : [0, 0, raw.downcase]
  end

  def search_index
    [
      name,
      quick_label,
      shirt_number,
      position,
      team&.name,
      category&.name,
      linked_teams.map(&:name),
      preferred_document
    ].compact.join(" ").downcase
  end

  def registration_label
    registration_submitted_at || created_at
  end

  def manageable_by?(user)
    user&.can_manage_athlete?(self)
  end

  def validate_registration!
    update!(status: :validado)
  end

  def block_registration!
    update!(status: :bloqueado)
  end

  def participated_matches
    Match.joins(:match_participations)
      .where(match_participations: { athlete_id: id, status: %w[confirmado convidado] })
      .distinct
  end

  def championship
    team&.championship || category&.championship || category&.championships&.first
  end

  def performance_summary
    return default_performance_summary if championship.blank?

    participations = match_participations.joins(:match).where(matches: { championship_id: championship.id })
    events = match_events.joins(:match).where(matches: { championship_id: championship.id })
    championship_suspensions = suspensions.where(championship_id: championship.id)

    {
      matches_played: participations.where(status: %w[confirmado convidado]).distinct.count(:match_id),
      participations_total: participations.distinct.count(:match_id),
      confirmed_participations: participations.where(status: "confirmado").distinct.count(:match_id),
      guest_participations: participations.where(status: "convidado").distinct.count(:match_id),
      absences: participations.where(status: "ausente").distinct.count(:match_id),
      goals: events.where(kind: "gol").count,
      assists: events.where(kind: "assistencia").count,
      fouls: events.select { |event| event.kind_outro? && event.notes.to_s.downcase.include?("falta") }.count,
      yellow_cards: events.where(kind: "cartao_amarelo").count,
      red_cards: events.where(kind: "cartao_vermelho").count,
      substitutions: events.where(kind: "substituicao").count,
      active_suspensions: championship_suspensions.status_ativa.count,
      total_suspensions: championship_suspensions.count,
      linked_teams_count: linked_teams.count,
      score: performance_score(events)
    }
  end

  def recent_performance_matches(limit = 5)
    return Match.none if championship.blank?

    Match.joins(:match_participations)
      .where(
        championship_id: championship.id,
        match_participations: {
          athlete_id: id,
          status: %w[confirmado convidado]
        }
      )
      .includes(:category, :team_a, :team_b, :winner)
      .distinct
      .order(scheduled_on: :desc, id: :desc)
      .limit(limit)
  end

  def recent_performance_events(limit = 8)
    return MatchEvent.none if championship.blank?

    match_events
      .joins(:match)
      .where(matches: { championship_id: championship.id })
      .includes(:match, :team)
      .order(created_at: :desc)
      .limit(limit)
  end

  def recent_performance_suspensions(limit = 5)
    return Suspension.none if championship.blank?

    suspensions
      .where(championship_id: championship.id)
      .includes(:match_event, :team, :category)
      .order(created_at: :desc)
      .limit(limit)
  end

  private

  def sync_primary_team_link
    # The importer has already synchronized this record in its transaction.
    # Consume the flag so future edits on the same instance still synchronize.
    if primary_team_link_imported
      self.primary_team_link_imported = false
      return
    end

    return if team_id.blank?

    TeamAthlete.find_or_create_by!(team_id: team_id, athlete_id: id) do |link|
      link.source_id = "team-athlete-#{team_id}-#{id}"
    end
  end

  def default_performance_summary
    {
      matches_played: 0,
      participations_total: 0,
      confirmed_participations: 0,
      guest_participations: 0,
      absences: 0,
      goals: 0,
      assists: 0,
      yellow_cards: 0,
      red_cards: 0,
      fouls: 0,
      substitutions: 0,
      active_suspensions: 0,
      total_suspensions: 0,
      linked_teams_count: linked_teams.count,
      score: 0
    }
  end

  def performance_score(events)
    goals = events.where(kind: "gol").count
    assists = events.where(kind: "assistencia").count
    yellows = events.where(kind: "cartao_amarelo").count
    reds = events.where(kind: "cartao_vermelho").count

    goals * 10 + assists * 4 - yellows * 2 - reds * 6
  end
end
