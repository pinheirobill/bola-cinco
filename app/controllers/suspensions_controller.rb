class SuspensionsController < ApplicationController
  def index
    return redirect_to championships_path, alert: "Crie ou selecione um campeonato antes de consultar suspensões." unless current_championship

    Discipline::SuspensionLifecycle.new(championship: scoped_championship).sweep_expired!
    @suspensions = scoped_suspensions.order(created_at: :desc)
    @suspension = scoped_championship.suspensions.new(status: :ativa, automatic: false, matches_count: 1)
    @categories = scoped_championship.categories.order(:name)
    @teams = Team.for_championship(scoped_championship).order(:name)
    @athletes = Athlete.for_championship(scoped_championship).includes(:team).order(:name)
    @match_events = MatchEvent.joins(:match).where(matches: { championship_id: scoped_championship.id }).includes(:match).order(created_at: :desc).limit(50)
    respond_to do |format|
      format.html
      format.json { render json: @suspensions }
    end
  end

  def show
    @suspension = suspension
    @categories = scoped_championship.categories.order(:name)
    @teams = Team.for_championship(scoped_championship).order(:name)
    @athletes = Athlete.for_championship(scoped_championship).includes(:team).order(:name)
    @match_events = MatchEvent.joins(:match).where(matches: { championship_id: scoped_championship.id }).includes(:match).order(created_at: :desc).limit(50)
    respond_to do |format|
      format.html
      format.json { render json: suspension }
    end
  end

  def create
    record = scoped_championship.suspensions.new(suspension_params)
    record.source_id = default_source_id("suspension") if record.source_id.blank?

    if html_form_submission?
      if record.save
        redirect_to suspension_path(record), notice: "Suspensão criada."
      else
        @suspensions = scoped_suspensions.order(created_at: :desc)
        @suspension = record
        @categories = scoped_championship.categories.order(:name)
        @teams = Team.for_championship(scoped_championship).order(:name)
        @athletes = Athlete.for_championship(scoped_championship).includes(:team).order(:name)
        @match_events = MatchEvent.joins(:match).where(matches: { championship_id: scoped_championship.id }).includes(:match).order(created_at: :desc).limit(50)
        render :index, status: :unprocessable_entity
      end
    elsif record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if autosave_request?
      if suspension.update(suspension_params)
        head :no_content
      else
        head :unprocessable_entity
      end
    elsif html_form_submission?
      if suspension.update(suspension_params)
        redirect_to suspension_path(suspension), notice: "Suspensão atualizada."
      else
        @suspension = suspension
        @categories = scoped_championship.categories.order(:name)
        @teams = Team.for_championship(scoped_championship).order(:name)
        @athletes = Athlete.for_championship(scoped_championship).includes(:team).order(:name)
        @match_events = MatchEvent.joins(:match).where(matches: { championship_id: scoped_championship.id }).includes(:match).order(created_at: :desc).limit(50)
        render :show, status: :unprocessable_entity
      end
    elsif suspension.update(suspension_params)
      render json: suspension
    else
      render json: { errors: suspension.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    suspension.destroy!

    return redirect_to suspensions_path, notice: "Suspensão removida." if html_form_submission?

    head :no_content
  end

  private

  def scoped_championship
    @scoped_championship ||= if params[:championship_id].present?
      Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
    else
      current_championship || raise(ActiveRecord::RecordNotFound)
    end
  end

  def scoped_suspensions
    @scoped_suspensions ||= scoped_championship.suspensions.includes(:championship, :category, :team, :athlete, :match_event)
  end

  def suspension
    @suspension ||= Suspension.find(params[:id])
  end

  def suspension_params
    params.expect(suspension: [
      :source_id,
      :category_id,
      :team_id,
      :athlete_id,
      :match_event_id,
      :reason,
      :status,
      :automatic,
      :matches_count,
      :starts_on,
      :ends_on,
      :notes,
      { source_data: {} }
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
