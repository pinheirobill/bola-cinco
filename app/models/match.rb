class Match < ApplicationRecord
  AUTO_GOAL_PREFIX = "auto-goal".freeze

  before_validation :sync_winner_from_score
  after_commit :sync_pending_participations!, on: %i[create update]

  belongs_to :championship
  belongs_to :category
  belongs_to :venue, optional: true
  belongs_to :team_a, class_name: "Team", optional: true
  belongs_to :team_b, class_name: "Team", optional: true
  belongs_to :winner, class_name: "Team", optional: true
  has_many :match_events, dependent: :destroy
  has_many :match_participations, dependent: :destroy
  has_one :match_report, dependent: :destroy

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

  validates :source_id, :code, :phase, presence: true
  validates :source_id, uniqueness: true

  def highlight_video_urls
    highlight_videos.presence || Array(source_data["highlight_videos"])
  end

  def venue_name
    venue&.name.presence || self[:venue]
  end

  def winner_label
    winner&.name.presence || "Calculado automaticamente pelo placar"
  end

  def classification_phase?
    phase.to_s.match?(/\A(classificatoria|classificatória|grupos?|fase[_\s-]?de[_\s-]?grupos?)\z/i)
  end

  def knockout_phase?
    phase.to_s.match?(/\A(mata[_\s-]?mata|oitavas?|quartas?|semifinais?|semifinal|final(?:es?)?)\z/i)
  end

  def sync_competition_state!
    championship.rebuild_standings! if classification_phase? && (status_finalizado? || status_wo?)
    championship.advance_knockout_from!(self) if knockout_phase? && (status_finalizado? || status_wo?)
  end

  def auto_goal_minutes_by_side
    {
      "a" => auto_goal_events_for("a").map { |event| event.minute&.to_s.presence || "" },
      "b" => auto_goal_events_for("b").map { |event| event.minute&.to_s.presence || "" }
    }
  end

  def roster_athletes
    roster_athlete_entries.map(&:last).uniq(&:id).sort_by do |athlete|
      [athlete.team&.name.to_s.downcase, athlete.shirt_number_sort_key, athlete.quick_label.downcase, athlete.name.downcase]
    end
  end

  def sync_auto_goal_events!(goal_minutes_a:, goal_minutes_b:)
    sync_auto_goal_events_for!("a", team_a, score_a.to_i, Array(goal_minutes_a))
    sync_auto_goal_events_for!("b", team_b, score_b.to_i, Array(goal_minutes_b))
  end

  def sync_pending_participations!
    roster_athlete_entries.each do |team, athlete|
      match_participations.find_or_create_by!(team_id: team.id, athlete_id: athlete.id) do |record|
        record.source_id = pending_participation_source_id(team, athlete)
        record.status = :pendente
      end
    end
  end

  private

  def sync_winner_from_score
    self.winner = resolved_winner
  end

  def auto_goal_events_for(side)
    match_events
      .select { |event| event.kind_gol? && event.source_data["auto_generated"] && event.source_data["auto_goal_side"].to_s == side.to_s }
      .sort_by { |event| event.source_data["auto_goal_index"].to_i }
  end

  def roster_athlete_entries
    [team_a, team_b].compact.flat_map do |team|
      team.athletes.includes(:team).map { |athlete| [team, athlete] }
    end
  end

  def sync_auto_goal_events_for!(side, team, count, minutes)
    events = auto_goal_events_for(side)

    count.times do |index|
      event = events[index] || match_events.find_by(source_id: auto_goal_source_id(side, index + 1)) || match_events.new(source_id: auto_goal_source_id(side, index + 1))
      event.assign_attributes(
        kind: :gol,
        team: team,
        minute: normalize_goal_minute(minutes[index]),
        notes: "Gol automático",
        source_data: event.source_data.merge(
          "auto_generated" => true,
          "auto_goal_side" => side.to_s,
          "auto_goal_index" => index + 1
        )
      )
      event.save!
    end

    events.drop(count).each(&:destroy!)
  end

  def auto_goal_source_id(side, index)
    "#{AUTO_GOAL_PREFIX}-#{id}-#{side}-#{index}"
  end

  def pending_participation_source_id(team, athlete)
    "match-participation-pending-#{id}-#{team.id}-#{athlete.id}"
  end

  def normalize_goal_minute(value)
    cleaned = value.to_s.strip
    return if cleaned.blank?

    cleaned.to_i
  end

  def resolved_winner
    return if team_a.blank? || team_b.blank?

    if wo.present?
      return team_b if wo == team_a.name
      return team_a if wo == team_b.name
    end

    if score_a.present? && score_b.present? && score_a != score_b
      return score_a.to_i > score_b.to_i ? team_a : team_b
    end

    if decision_penaltis? && penalties_a.present? && penalties_b.present? && penalties_a != penalties_b
      return penalties_a.to_i > penalties_b.to_i ? team_a : team_b
    end

    nil
  end
end
