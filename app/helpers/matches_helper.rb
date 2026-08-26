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
      [event.minute.present? ? "#{event.minute}'" : nil, event.period.presence].compact.join(" · ").presence || kind.to_s.humanize
    end
  end

  def match_participation_status_options
    MATCH_PARTICIPATION_STATUSES.map { |value, data| [data[:label], value] }
  end

  def match_participation_status_badge(status)
    MATCH_PARTICIPATION_STATUSES.fetch(status.to_s, { label: status.to_s.humanize, badge: "badge-outline" })
  end
end
