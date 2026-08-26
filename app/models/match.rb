class Match < ApplicationRecord
  AUTO_GOAL_PREFIX = "auto-goal".freeze
  EVENT_SHEET_PREFIX = "event-sheet".freeze
  EVENT_SHEET_KINDS = {
    yellow_card: "cartao_amarelo",
    red_card: "cartao_vermelho",
    goal_minutes: "gol",
    substitution_minutes: "substituicao"
  }.freeze

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

  def auto_goal_penalties_by_side
    {
      "a" => auto_goal_events_for("a").map { |event| event.source_data["penalty"] == true },
      "b" => auto_goal_events_for("b").map { |event| event.source_data["penalty"] == true }
    }
  end

  def roster_athletes
    roster_athlete_entries.map(&:last).uniq(&:id).sort_by do |athlete|
      [athlete.team&.name.to_s.downcase, athlete.shirt_number_sort_key, athlete.quick_label.downcase, athlete.name.downcase]
    end
  end

  def sync_auto_goal_events!(goal_minutes_a:, goal_minutes_b:, goal_penalties_a: [], goal_penalties_b: [])
    sync_auto_goal_events_for!("a", team_a, score_a.to_i, Array(goal_minutes_a), Array(goal_penalties_a))
    sync_auto_goal_events_for!("b", team_b, score_b.to_i, Array(goal_minutes_b), Array(goal_penalties_b))
  end

  def sync_event_sheet!(sheet_params)
    sheet = normalize_event_sheet_params(sheet_params)
    managed_source_ids = []

    roster_athlete_entries.each do |team, athlete|
      team_sheet = sheet[team_event_sheet_key(team)]
      next if team_sheet.blank?

      athlete_sheet = team_sheet[athlete.id.to_s]
      next if athlete_sheet.blank?

      managed_source_ids.concat(sync_event_sheet_row!(team, athlete, athlete_sheet))
    end

    destroy_event_sheet_records_not_in(managed_source_ids)
  end

  def event_sheet_state_for(team, athlete)
    {
      yellow_card: event_sheet_events_for(team, athlete, "cartao_amarelo").any?,
      red_card: event_sheet_events_for(team, athlete, "cartao_vermelho").any?,
      goal_minutes: event_sheet_events_for(team, athlete, "gol").map { |event| event.minute&.to_s.presence }.compact.join(", "),
      substitution_minutes: event_sheet_events_for(team, athlete, "substituicao").map { |event| event.minute&.to_s.presence }.compact.join(", ")
    }
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

  def sync_auto_goal_events_for!(side, team, count, minutes, penalties)
    events = auto_goal_events_for(side)

    count.times do |index|
      event = events[index] || match_events.find_by(source_id: auto_goal_source_id(side, index + 1)) || match_events.new(source_id: auto_goal_source_id(side, index + 1))
      penalty = [true, "true", 1, "1"].include?(penalties[index])
      event.assign_attributes(
        kind: :gol,
        team: team,
        minute: normalize_goal_minute(minutes[index]),
        notes: penalty ? "Gol automático de pênalti" : "Gol automático",
        source_data: event.source_data.merge(
          "auto_generated" => true,
          "auto_goal_side" => side.to_s,
          "auto_goal_index" => index + 1,
          "penalty" => penalty
        )
      )
      event.save!
    end

    events.drop(count).each(&:destroy!)
  end

  def sync_event_sheet_row!(team, athlete, row_params)
    managed_source_ids = []

    managed_source_ids.concat(sync_event_sheet_boolean!(team, athlete, "cartao_amarelo", row_params[:yellow_card], "Cartão amarelo da súmula"))
    managed_source_ids.concat(sync_event_sheet_boolean!(team, athlete, "cartao_vermelho", row_params[:red_card], "Cartão vermelho da súmula"))
    managed_source_ids.concat(sync_event_sheet_minutes!(team, athlete, "gol", row_params[:goal_minutes], "Gol lançado pela súmula"))
    managed_source_ids.concat(sync_event_sheet_minutes!(team, athlete, "substituicao", row_params[:substitution_minutes], "Substituição lançada pela súmula"))

    managed_source_ids
  end

  def sync_event_sheet_boolean!(team, athlete, kind, value, notes)
    events = event_sheet_events_for(team, athlete, kind)
    managed_source_ids = []

    if truthy_param?(value)
      event = match_events.find_by(source_id: event_sheet_source_id(team, athlete, kind, 1)) || events.first || match_events.find_or_initialize_by(source_id: event_sheet_source_id(team, athlete, kind, 1))
      event.assign_attributes(
        kind: kind,
        team: team,
        athlete: athlete,
        minute: nil,
        period: nil,
        notes: notes,
        source_data: event.source_data.merge(
          "event_sheet" => true,
          "event_sheet_kind" => kind,
          "event_sheet_index" => 1
        )
      )
      event.source_id = event_sheet_source_id(team, athlete, kind, 1)
      event.save!
      managed_source_ids << event.source_id
    end

    events.reject { |event| managed_source_ids.include?(event.source_id) }.each(&:destroy!)
    managed_source_ids
  end

  def sync_event_sheet_minutes!(team, athlete, kind, value, notes)
    minutes = normalize_event_sheet_minutes(value)
    events = event_sheet_events_for(team, athlete, kind)
    managed_source_ids = []

    minutes.each_with_index do |minute, index|
      event = match_events.find_by(source_id: event_sheet_source_id(team, athlete, kind, index + 1)) || events[index] || match_events.find_or_initialize_by(source_id: event_sheet_source_id(team, athlete, kind, index + 1))
      event.assign_attributes(
        kind: kind,
        team: team,
        athlete: athlete,
        minute: minute,
        period: nil,
        notes: notes,
        source_data: event.source_data.merge(
          "event_sheet" => true,
          "event_sheet_kind" => kind,
          "event_sheet_index" => index + 1
        )
      )
      event.source_id = event_sheet_source_id(team, athlete, kind, index + 1)
      event.save!
      managed_source_ids << event.source_id
    end

    events.reject { |event| managed_source_ids.include?(event.source_id) }.each(&:destroy!)
    managed_source_ids
  end

  def auto_goal_source_id(side, index)
    "#{AUTO_GOAL_PREFIX}-#{id}-#{side}-#{index}"
  end

  def pending_participation_source_id(team, athlete)
    "match-participation-pending-#{id}-#{team.id}-#{athlete.id}"
  end

  def event_sheet_events_for(team, athlete, kind)
    match_events
      .select { |event| event.team_id == team.id && event.athlete_id == athlete.id && event.kind == kind.to_s }
      .sort_by { |event| [event.minute.to_i, event.created_at || Time.zone.at(0), event.id.to_i] }
  end

  def event_sheet_source_id(team, athlete, kind, index)
    "#{EVENT_SHEET_PREFIX}-#{id}-#{team.id}-#{athlete.id}-#{kind}-#{index}"
  end

  def team_event_sheet_key(team)
    return "team_a" if team == team_a
    return "team_b" if team == team_b

    nil
  end

  def normalize_event_sheet_params(sheet_params)
    return {} if sheet_params.blank?

    sheet_params.to_h.with_indifferent_access
  end

  def normalize_event_sheet_minutes(value)
    value.to_s.split(/[,\n;]+/).map(&:strip).reject(&:blank?).filter_map do |part|
      next if part.blank?

      cleaned = part.gsub(/[^\d]/, "")
      next if cleaned.blank?

      cleaned.to_i
    end
  end

  def truthy_param?(value)
    [true, "true", 1, "1", "on", "yes"].include?(value)
  end

  def destroy_event_sheet_records_not_in(source_ids)
    allowed = Array(source_ids).compact_blank.uniq

    match_events
      .select { |event| event.source_id.start_with?("#{EVENT_SHEET_PREFIX}-#{id}-") && !allowed.include?(event.source_id) }
      .each(&:destroy!)
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
