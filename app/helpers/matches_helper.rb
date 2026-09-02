module MatchesHelper
  MATCH_EVENT_COLUMNS = [
    { kind: "gol", label: "Gol", badge: "badge-success" },
    { kind: "assistencia", label: "Assist.", badge: "badge-info" },
    { kind: "cartao_amarelo", label: "Amarelo", badge: "badge-warning" },
    { kind: "cartao_vermelho", label: "Vermelho", badge: "badge-error" },
    { kind: "substituicao", label: "Subst.", badge: "badge-neutral" },
    { kind: "outro", label: "Outro", badge: "badge-outline" }
  ].freeze

  MATCH_PARTICIPATION_STATUSES = {
    "pendente" => { label: "Pendente", badge: "badge-warning" },
    "confirmado" => { label: "Confirmado", badge: "badge-success" },
    "ausente" => { label: "Ausente", badge: "badge-error" },
    "convidado" => { label: "Convidado", badge: "badge-info" }
  }.freeze

  def match_event_columns
    MATCH_EVENT_COLUMNS
  end

  def match_event_marks_for(match_events, athlete, kind)
    Array(match_events).select { |event| event.athlete_id == athlete.id && event.kind == kind.to_s }.map do |event|
      marks = [event.minute.present? ? "#{event.minute}'" : nil, event.period.presence]
      marks << "Pênalti" if kind.to_s == "gol" && event.source_data["penalty"] == true
      marks.compact.join(" · ").presence || kind.to_s.humanize
    end
  end

  def match_event_sheet_field_name(side, athlete_id, field)
    "match[event_sheet][#{side}][#{athlete_id}][#{field}]"
  end

  def match_event_sheet_field_id(side, athlete_id, field)
    "match_event_sheet_#{side}_#{athlete_id}_#{field}"
  end

  def match_event_sheet_state(match, team, athlete)
    state = match.event_sheet_state_for(team, athlete)
    goal_minutes_list = Array(state[:goal_minutes_list]).map(&:to_s)
    substitution_minutes_list = Array(state[:substitution_minutes_list]).map(&:to_s)

    {
      yellow_card: state[:yellow_card],
      red_card: state[:red_card],
      goal_minutes: state[:goal_minutes],
      goal_minutes_list: goal_minutes_list,
      substitution_minutes: state[:substitution_minutes],
      substitution_minutes_list: substitution_minutes_list
    }
  end

  def match_event_sheet_minutes_list(state, field, count: nil)
    minutes = Array(state[:"#{field}_minutes_list"]).map(&:to_s)
    minutes = [""] if minutes.blank?

    if count.present?
      minutes = minutes.first(count)
      minutes.fill("", minutes.length...count)
    end

    minutes
  end

  def match_event_sheet_participation_badge(participation)
    return { label: "Sem vínculo", badge: "badge-outline" } if participation.blank?

    match_participation_status_badge(participation.status)
  end

  def match_participation_status_options
    MATCH_PARTICIPATION_STATUSES.map { |value, data| [data[:label], value] }
  end

  def match_participation_status_field_id(side, athlete_id)
    "match_participation_status_#{side}_#{athlete_id}"
  end

  def match_participation_status_badge(status)
    MATCH_PARTICIPATION_STATUSES.fetch(status.to_s, { label: status.to_s.humanize, badge: "badge-outline" })
  end

  def match_scheduled_time_value(value)
    raw = value.to_s.strip
    return if raw.blank?

    if (match = raw.match(/\A(?<hour>\d{1,2})[Hh:](?<minute>\d{2})\z/))
      hour = match[:hour].to_i
      minute = match[:minute].to_i
      return format("%02d:%02d", hour, minute)
    end

    if (match = raw.match(/\A(?<hour>\d{1,2}):(?<minute>\d{2})(?::\d{2})?\z/))
      hour = match[:hour].to_i
      minute = match[:minute].to_i
      return format("%02d:%02d", hour, minute)
    end

    raw
  end
end
