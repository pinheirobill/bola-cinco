class MatchEventsController < ApplicationController
  def index
    @match_events = scoped_match_events.order(created_at: :desc)
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
    record = match.match_events.new(match_event_params)
    record.source_id = default_source_id("event") if record.source_id.blank?

    MatchEvent.transaction do
      record.save!
      Discipline::AutomaticSuspensionGenerator.new(championship: match.championship).call
    end

    if html_form_submission?
      redirect_to edit_match_path(match), notice: "Evento registrado."
    else
      render json: record, status: :created
    end
  rescue ActiveRecord::RecordInvalid
    if html_form_submission?
      load_match_sheet_context(match)
      @match_event = record
      render "matches/edit", status: :unprocessable_entity
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

    return redirect_to match_path(match_event.match), notice: "Evento removido." if html_form_submission?

    head :no_content
  end

  private

  def scoped_match_events
    scope = MatchEvent.includes(:match, :team, :athlete)
    scope = scope.where(match_id: params[:match_id]) if params[:match_id].present?
    scope
  end

  def match
    @match ||= Match.find(params[:match_id])
  end

  def match_event
    @match_event ||= MatchEvent.find(params[:id])
  end

  def match_event_params
    params.expect(match_event: [
      :source_id,
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
