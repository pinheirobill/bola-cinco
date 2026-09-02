class Match < ApplicationRecord
  EVENT_SHEET_PREFIX = "event-sheet".freeze
  EVENT_SHEET_KINDS = {
    yellow_card: "cartao_amarelo",
    red_card: "cartao_vermelho",
    goal_minutes: "gol",
    substitution_minutes: "substituicao"
  }.freeze

  before_validation :sync_winner_from_score
  after_commit :sync_pending_participations!, on: %i[create update]
  after_commit :sync_tranca_mirror!, on: %i[create update destroy]

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
    return team_a_label if winner.present? && winner == team_a
    return team_b_label if winner.present? && winner == team_b
    return winner&.name.presence if winner.present?

    "Calculado automaticamente pelo placar"
  end

  def team_a_label
    resolved_match_team_label(team_a, source_a)
  end

  def team_b_label
    resolved_match_team_label(team_b, source_b)
  end

  def teams_label
    [team_a_label, team_b_label].compact.join(" x ").presence || "Confronto a definir"
  end

  def knockout_team_a
    team_a.presence || team_from_source(source_a)
  end

  def knockout_team_b
    team_b.presence || team_from_source(source_b)
  end

  def knockout_winner
    return if knockout_team_a.blank? || knockout_team_b.blank?

    if wo.present?
      return knockout_team_b if wo == knockout_team_a.name
      return knockout_team_a if wo == knockout_team_b.name
    end

    if score_a.present? && score_b.present? && score_a != score_b
      return score_a.to_i > score_b.to_i ? knockout_team_a : knockout_team_b
    end

    if decision_penaltis? && penalties_a.present? && penalties_b.present? && penalties_a != penalties_b
      return penalties_a.to_i > penalties_b.to_i ? knockout_team_a : knockout_team_b
    end

    nil
  end

  def classification_phase?
    phase.to_s.match?(/\A(classificatoria|classificatória|grupos?|fase[_\s-]?de[_\s-]?grupos?)\z/i)
  end

  def knockout_phase?
    phase.to_s.match?(/\A(mata[_\s-]?mata|oitavas?|quartas?|semifinais?|semifinal|final(?:es?)?)\z/i)
  end

  def sync_competition_state!
    championship.rebuild_standings! if classification_phase? && (status_finalizado? || status_wo?)
    championship.advance_group_stage_knockout_from!(self) if classification_phase? && (status_finalizado? || status_wo?)
    championship.advance_knockout_from!(self) if knockout_phase? && (status_finalizado? || status_wo?)
  end

  def roster_athletes
    roster_athlete_entries.map(&:last).uniq(&:id).sort_by do |athlete|
      [athlete.team&.name.to_s.downcase, athlete.shirt_number_sort_key, athlete.quick_label.downcase, athlete.name.downcase]
    end
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
    goal_events = event_sheet_events_for(team, athlete, "gol")
    goal_minutes_list = goal_events.map { |event| event.minute&.to_s.presence || "" }
    substitution_events = event_sheet_events_for(team, athlete, "substituicao")
    substitution_minutes_list = substitution_events.map { |event| event.minute&.to_s.presence || "" }

    {
      yellow_card: event_sheet_events_for(team, athlete, "cartao_amarelo").any?,
      red_card: event_sheet_events_for(team, athlete, "cartao_vermelho").any?,
      goal_minutes: goal_minutes_list.reject(&:blank?).join(", "),
      goal_minutes_list: goal_minutes_list,
      substitution_minutes: substitution_minutes_list.reject(&:blank?).join(", "),
      substitution_minutes_list: substitution_minutes_list
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

  def sync_tranca_mirror!
    return unless championship&.tranca?

    if destroyed?
      Tranca::Partida.find_by(source_id: source_id)&.destroy!
      return
    end

    tranca_dupla_a = Tranca::Dupla.find_by(source_id: team_a&.source_id)
    tranca_dupla_b = Tranca::Dupla.find_by(source_id: team_b&.source_id)
    tranca_winner = Tranca::Dupla.find_by(source_id: winner&.source_id)

    tranca_rodada = Tranca::Rodada.find_or_initialize_by(
      championship_id: championship_id,
      phase: phase,
      round_number: round_number.to_i
    )
    tranca_rodada.assign_attributes(
      championship: championship,
      source_id: "tranca-round-#{championship.source_id}-#{phase}-#{round_number}",
      label: tranca_round_label,
      status: tranca_round_status_for,
      starts_on: scheduled_on,
      ends_on: scheduled_on
    )
    tranca_rodada.save!

    tranca_mesa = Tranca::Mesa.find_or_initialize_by(
      championship_id: championship_id,
      code: code
    )
    tranca_mesa.assign_attributes(
      championship: championship,
      tranca_rodada: tranca_rodada,
      source_id: "tranca-mesa-#{source_id}",
      name: venue_name.presence || "Mesa #{code}",
      location: venue_name,
      status: tranca_mesa_status_for
    )
    tranca_mesa.save!

    tranca_partida = Tranca::Partida.find_or_initialize_by(source_id: source_id)
    tranca_partida.assign_attributes(
      championship: championship,
      category: category,
      tranca_rodada: tranca_rodada,
      tranca_mesa: tranca_mesa,
      dupla_a: tranca_dupla_a,
      dupla_b: tranca_dupla_b,
      winner: tranca_winner,
      code: code,
      phase: phase,
      round_number: round_number,
      group_key: group_key,
      scheduled_on: scheduled_on,
      scheduled_time: scheduled_time,
      status: status,
      score_a: score_a,
      score_b: score_b,
      decision: decision,
      penalties_a: penalties_a,
      penalties_b: penalties_b,
      wo: wo,
      source_data: source_data
    )
    tranca_partida.save!
  end

  def sync_winner_from_score
    manual_winner = association(:winner).reader

    if manual_winner.present? && (score_a == score_b || score_a.blank? || score_b.blank? || status_wo?)
      self.winner = manual_winner
      return
    end

    self.winner = knockout_winner
  end

  def roster_athlete_entries
    [team_a, team_b].compact.flat_map do |team|
      team.athletes.includes(:team).map { |athlete| [team, athlete] }
    end
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
    minutes = normalize_event_sheet_minutes_list(value)
    events = event_sheet_events_for(team, athlete, kind)
    managed_source_ids = []

    minutes.length.times do |index|
      minute = minutes[index]
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

  def tranca_round_label
    phase_label = case phase.to_s
    when "classificatoria" then "Classificatória"
    when "mata_mata" then "Mata-mata"
    else phase.to_s.tr("_", " ").humanize
    end

    round_number.to_i.positive? ? "Rodada #{round_number} · #{phase_label}" : phase_label
  end

  def tranca_round_status_for
    case status.to_s
    when "finalizado", "wo" then "encerrada"
    when "em_andamento" then "em_andamento"
    else "programada"
    end
  end

  def tranca_mesa_status_for
    case status.to_s
    when "finalizado", "wo" then "ocupada"
    when "em_andamento" then "em_uso"
    else "disponivel"
    end
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

  def normalize_event_sheet_minutes_list(value)
    values =
      if value.is_a?(Array)
        value
      else
        value.to_s.split(/[,\n;]+/)
      end

    values.map { |part| part.to_s.strip }.reject(&:blank?)
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

  def resolved_match_team_label(team, source)
    return team&.name.presence if team.present?
    return unless status_finalizado? || status_wo?

    import_source_team_name(source)
  end

  def import_source_team_name(source)
    label = if source.respond_to?(:[])
      source["name"].presence || source[:name].presence
    else
      source.to_s.presence
    end

    label if actual_knockout_team_label?(label)
  end

  def team_from_source(source)
    label = if source.respond_to?(:[])
      source["name"].presence || source[:name].presence
    else
      source.to_s.presence
    end

    return if label.blank?

    [label, canonical_knockout_source_label(label)].compact.each do |candidate_label|
      team = championship&.teams&.find do |candidate|
        candidate.name.to_s.strip.casecmp?(candidate_label.to_s.strip)
      end
      return team if team.present?
    end

    championship&.teams&.find_by(name: canonical_knockout_source_label(label)) || championship&.teams&.find_by(name: label)
  end

  def canonical_knockout_source_label(label)
    normalized = label.to_s.strip.upcase
    knockout_source_aliases.fetch(normalized, label)
  end

  def knockout_source_aliases
    aliases = {}

    if defined?(BolaCinco::ChisCupWorkbookImporter::TEAM_ALIASES)
      aliases.merge!(BolaCinco::ChisCupWorkbookImporter::TEAM_ALIASES)
    end

    if defined?(BolaCinco::ChampionshipWorkbookImporter::TEAM_ALIASES)
      aliases.merge!(BolaCinco::ChampionshipWorkbookImporter::TEAM_ALIASES)
    end

    aliases
  end

  def actual_knockout_team_label?(label)
    normalized = label.to_s.squish.upcase
    return false if normalized.blank?
    return false if normalized.match?(/\A(?:A DEFINIR|CONFRONTO A DEFINIR)\z/)
    return false if normalized.match?(/\A(?:VENC|PERD|SF\d+|CHAVE-|TITULO|FINAL|1[ºO]|2[ºO]|3[ºO]|4[ºO])\b/)

    true
  end
end
