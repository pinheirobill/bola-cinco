class MatchEventsController < ApplicationController
  MONTH_LABELS = {
    "01" => "Janeiro",
    "02" => "Fevereiro",
    "03" => "Março",
    "04" => "Abril",
    "05" => "Maio",
    "06" => "Junho",
    "07" => "Julho",
    "08" => "Agosto",
    "09" => "Setembro",
    "10" => "Outubro",
    "11" => "Novembro",
    "12" => "Dezembro"
  }.freeze

  helper_method :event_month_label, :kind_fill_class

  def index
    @available_championships = accessible_championships
    @available_teams = Team.joins(category: :championships)
      .where(championships: { id: @available_championships.select(:id) })
      .includes(:category)
      .order(:name)
    @available_athletes = Athlete.joins(category: :championships)
      .where(championships: { id: @available_championships.select(:id) })
      .includes(:team, :category)
      .order(:name)
    @available_months = available_months
    @selected_championship_id = filter_value(:championship_id, current_championship&.id)
    @selected_team_id = filter_value(:team_id)
    @selected_athlete_id = filter_value(:athlete_id)
    @selected_month = filter_value(:month)
    @selected_championship = selected_championship_record
    @selected_team = selected_team_record
    @selected_athlete = selected_athlete_record

    @match_events = filtered_match_events
    @dashboard_stats = dashboard_stats(@match_events)
    @event_kind_breakdown = breakdown_by_kind(@match_events)
    @monthly_breakdown = breakdown_by_month(@match_events)
    @focus_championship = @selected_championship || current_championship || accessible_championships.first
    @focus_mode = if @selected_athlete.present?
      :athlete
    elsif @selected_team.present?
      :team
    else
      :championship
    end
    @championship_rankings = championship_rankings(@focus_championship)
    @team_focus = team_focus_data(@selected_team, @focus_championship) if @selected_team.present?
    @athlete_focus = athlete_focus_data(@selected_athlete, @focus_championship) if @selected_athlete.present?

    respond_to do |format|
      format.html
      format.json { render json: @match_events }
    end
  end

  def show
    @match_event = match_event
    respond_to do |format|
      format.html
      format.json { render json: match_event }
    end
  end

  def create
    record = match_event_scope.new(match_event_params)
    record.source_id = default_source_id("event") if record.source_id.blank?

    MatchEvent.transaction do
      record.save!
      Discipline::AutomaticSuspensionGenerator.new(championship: record.championship).call if record.championship.present?
    end

    if html_form_submission?
      redirect_to return_path_for(record), notice: "Evento registrado."
    else
      render json: record, status: :created
    end
  rescue ActiveRecord::RecordInvalid
    if html_form_submission?
      @match_event = record
      if match.present?
        load_match_sheet_context(match)
        render "matches/edit", status: :unprocessable_entity
      else
        @match_events = scoped_match_events.order(created_at: :desc)
        render :index, status: :unprocessable_entity
      end
    else
      if record.errors.any?
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      else
        render json: { errors: ["Não foi possível registrar o evento."] }, status: :unprocessable_entity
      end
    end
  end

  def update
    if html_form_submission?
      if match_event.update(match_event_params)
        redirect_to match_event_path(match_event), notice: "Evento atualizado."
      else
        @match_event = match_event
        render :show, status: :unprocessable_entity
      end
    elsif match_event.update(match_event_params)
      render json: match_event
    else
      render json: { errors: match_event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    match_event.destroy!

    return redirect_to return_path_for(match_event), notice: "Evento removido." if html_form_submission?

    head :no_content
  end

  private

  def scoped_match_events
    scope = MatchEvent.includes(:championship, :match, :team, :athlete)
    scope = scope.where(match_id: params[:match_id]) if params[:match_id].present?
    scope = scope.where(championship_id: params[:championship_id]) if params[:championship_id].present?
    scope
  end

  def filtered_match_events
    scope = scoped_match_events

    if @selected_championship_id.present?
      scope = scope.where(championship_id: @selected_championship_id)
    end

    if @selected_team_id.present?
      scope = scope.where(team_id: @selected_team_id)
    end

    if @selected_athlete_id.present?
      scope = scope.where(athlete_id: @selected_athlete_id)
    end

    events = scope.order(created_at: :desc).to_a
    return events if @selected_month.blank?

    events.select { |event| event_month_key(event) == @selected_month }
  end

  def dashboard_stats(events)
    {
      total: events.size,
      goals: events.count(&:kind_gol?),
      cards: events.count { |event| event.kind_cartao_amarelo? || event.kind_cartao_vermelho? },
      substitutions: events.count(&:kind_substituicao?),
      months: events.map { |event| event_month_key(event) }.uniq.size
    }
  end

  def breakdown_by_kind(events)
    labels = {
      "gol" => "Gols",
      "assistencia" => "Assistências",
      "cartao_amarelo" => "Amarelos",
      "cartao_vermelho" => "Vermelhos",
      "substituicao" => "Substituições",
      "outro" => "Outros"
    }

    events.group_by(&:kind).map do |kind, grouped|
      {
        key: kind,
        label: labels.fetch(kind, kind.humanize),
        count: grouped.size,
        badge_class: kind_badge_class(kind)
      }
    end.sort_by { |entry| -entry[:count] }
  end

  def breakdown_by_month(events)
    events.group_by { |event| event_month_key(event) }.map do |month_key, grouped|
      {
        key: month_key,
        label: event_month_label(month_key),
        count: grouped.size
      }
    end.sort_by { |entry| entry[:key] }.reverse
  end

  def championship_rankings(championship)
    return { top_teams: [], bottom_teams: [], top_athletes: [] } if championship.blank?

    rows = championship.standing_rows.includes(:team, :category).order(points: :desc, goal_diff: :desc, goals_for: :desc)
    athletes = championship.athletes.includes(:team, :category, :linked_teams).map do |athlete|
      summary = athlete.performance_summary

      {
        athlete: athlete,
        summary: summary,
        score: summary[:score].to_i
      }
    end.sort_by { |entry| -entry[:score] }

    {
      top_teams: rows.limit(3),
      bottom_teams: rows.order(points: :asc, goal_diff: :asc, goals_for: :asc).limit(3),
      top_athletes: athletes.first(3)
    }
  end

  def team_focus_data(team, championship)
    return nil if team.blank?

    focus_championship = championship || team.championship || team.category&.championship || team.category&.championships&.first
    team_rows = focus_championship&.standing_rows&.includes(:team, :category)&.find_by(team_id: team.id)
    team_events = match_events_for_team(team, focus_championship)
    team_athletes = team.athletes.includes(:team, :category, :linked_teams)

    {
      team: team,
      championship: focus_championship,
      row: team_rows,
      matches_played: focus_championship ? focus_championship.matches.where("team_a_id = :id OR team_b_id = :id", id: team.id).count : team.home_matches.count + team.away_matches.count,
      goals_for: team_rows&.goals_for.to_i,
      goals_against: team_rows&.goals_against.to_i,
      points: team_rows&.points.to_i,
      goal_diff: team_rows&.goal_diff.to_i,
      event_breakdown: breakdown_by_kind(team_events),
      monthly_breakdown: breakdown_by_month(team_events),
      top_athletes: team_athletes.map do |athlete|
        summary = athlete.performance_summary
        { athlete: athlete, summary: summary, score: summary[:score].to_i }
      end.sort_by { |entry| -entry[:score] }.first(3)
    }
  end

  def athlete_focus_data(athlete, championship)
    return nil if athlete.blank?

    focus_championship = championship || athlete.championship
    summary = athlete.performance_summary
    athlete_events = match_events_for_athlete(athlete, focus_championship)

    {
      athlete: athlete,
      summary: summary,
      event_breakdown: breakdown_by_kind(athlete_events),
      monthly_breakdown: breakdown_by_month(athlete_events),
      recent_teams: athlete.linked_teams.includes(:category).limit(3)
    }
  end

  def match
    @match ||= Match.find(params[:match_id]) if params[:match_id].present?
  end

  def match_event
    @match_event ||= MatchEvent.find(params[:id])
  end

  def match_event_params
    params.expect(match_event: [
      :source_id,
      :championship_id,
      :team_id,
      :athlete_id,
      :kind,
      :minute,
      :period,
      :notes,
      { source_data: {} }
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def match_event_scope
    return match.match_events if match.present?
    return scoped_championship.match_events if params[:championship_id].present?

    MatchEvent.all
  end

  def scoped_championship
    @scoped_championship ||= Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
  end

  def return_path_for(record)
    return edit_match_path(record.match) if record.match.present?
    return match_events_path(championship_id: record.championship_id) if record.championship.present?

    match_events_path
  end

  def selected_championship_record
    return nil if @selected_championship_id.blank?

    accessible_championships.find { |championship| championship.id.to_s == @selected_championship_id.to_s }
  end

  def selected_team_record
    return nil if @selected_team_id.blank?

    @available_teams.find { |team| team.id.to_s == @selected_team_id.to_s }
  end

  def selected_athlete_record
    return nil if @selected_athlete_id.blank?

    @available_athletes.find { |athlete| athlete.id.to_s == @selected_athlete_id.to_s }
  end

  def accessible_championships
    @accessible_championships ||= begin
      scope = current_user.admin? ? Championship.all : current_user.accessible_championships
      scope.order(season: :desc, created_at: :desc)
    end
  end

  def available_months
    scoped_match_events
      .order(created_at: :desc)
      .to_a
      .map { |event| event_month_key(event) }
      .uniq
  end

  def filter_value(key, default = nil)
    params.key?(key) ? params[key].presence : default
  end

  def event_month_key(event)
    event_timestamp(event).strftime("%Y-%m")
  end

  def event_month_label(month_key)
    year, month = month_key.to_s.split("-", 2)
    return month_key.to_s if year.blank? || month.blank?

    "#{MONTH_LABELS.fetch(month, month)} #{year}"
  end

  def event_timestamp(event)
    (event.match&.scheduled_on || event.created_at || Time.current).to_date
  end

  def match_events_for_team(team, championship)
    scope = MatchEvent.where(team_id: team.id).includes(:championship, :match, :team, :athlete)
    scope = scope.where(championship_id: championship.id) if championship.present?
    scope.order(created_at: :desc)
  end

  def match_events_for_athlete(athlete, championship)
    scope = MatchEvent.where(athlete_id: athlete.id).includes(:championship, :match, :team, :athlete)
    scope = scope.where(championship_id: championship.id) if championship.present?
    scope.order(created_at: :desc)
  end

  def kind_badge_class(kind)
    case kind.to_s
    when "gol" then "badge-success"
    when "assistencia" then "badge-info"
    when "cartao_amarelo" then "badge-warning"
    when "cartao_vermelho" then "badge-error"
    when "substituicao" then "badge-secondary"
    else "badge-neutral"
    end
  end

  def kind_fill_class(kind)
    case kind.to_s
    when "gol" then "bg-success"
    when "assistencia" then "bg-info"
    when "cartao_amarelo" then "bg-warning"
    when "cartao_vermelho" then "bg-error"
    when "substituicao" then "bg-secondary"
    else "bg-base-content/40"
    end
  end

  def load_match_sheet_context(match_record)
    @match = match_record
    @match_report = @match.match_report || @match.build_match_report(status: :rascunho, source_id: "report-#{@match.source_id}")
    @available_referees = @match.championship.referees.order(:name)
    @available_athletes = @match.roster_athletes
    @available_teams = [@match.team_a, @match.team_b].compact.uniq
    @available_venues = @match.championship.venues.order(:name)
    @match_events = @match.match_events.includes(:team, :athlete).order(created_at: :desc)
    @team_a_athletes = @match.team_a&.athletes&.includes(:team)&.order(:shirt_number, :name) || Athlete.none
    @team_b_athletes = @match.team_b&.athletes&.includes(:team)&.order(:shirt_number, :name) || Athlete.none
  end
end
