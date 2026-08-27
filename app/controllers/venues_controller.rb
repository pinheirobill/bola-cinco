class VenuesController < ApplicationController
  def index
    @venues = scoped_venues.order(:name)
    @venue = scoped_championship.venues.new(status: :ativo)
    respond_to do |format|
      format.html
      format.json { render json: @venues }
    end
  end

  def show
    @venue = venue
    load_venue_dashboard
    respond_to do |format|
      format.html
      format.json { render json: venue }
    end
  end

  def create
    record = scoped_championship.venues.new(venue_params)
    record.source_id = default_source_id("venue") if record.source_id.blank?

    if html_form_submission?
      if record.save
        redirect_to venue_path(record), notice: "Local criado."
      else
        @venues = scoped_venues.order(:name)
        @venue = record
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
      if venue.update(venue_params)
        head :no_content
      else
        head :unprocessable_entity
      end
    elsif html_form_submission?
      if venue.update(venue_params)
        redirect_to venue_path(venue), notice: "Local atualizado."
      else
        @venue = venue
        render :show, status: :unprocessable_entity
      end
    elsif venue.update(venue_params)
      render json: venue
    else
      render json: { errors: venue.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def attach
    venue.update!(championship: scoped_championship)
    redirect_back fallback_location: setup_championship_path(scoped_championship, step: "teams"), notice: "Local vinculado ao campeonato."
  end

  def detach
    venue.update!(championship: nil)
    redirect_back fallback_location: setup_championship_path(scoped_championship, step: "teams"), notice: "Local desvinculado do campeonato."
  end

  def destroy
    venue.destroy!

    return redirect_to venues_path, notice: "Local removido." if html_form_submission?

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

  def scoped_venues
    @scoped_venues ||= scoped_championship.venues.includes(:championship)
  end

  def venue
    @venue ||= Venue.find(params[:id])
  end

  def venue_params
    params.expect(venue: [
      :source_id,
      :name,
      :short_name,
      :city,
      :address,
      :notes,
      :status,
      :championship_id
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def load_venue_dashboard
    @venue_matches = @venue.matches.includes(:championship, :category, :team_a, :team_b, :winner).order(:scheduled_on, :scheduled_time, :id).to_a
    @venue_completed_matches = @venue_matches.select { |match| match.status_finalizado? || match.status_wo? }
    @venue_pending_matches = @venue_matches.reject { |match| match.status_finalizado? || match.status_wo? || match.status_cancelado? }
    @venue_total_matches = @venue_matches.size
    @venue_total_goals = @venue_completed_matches.sum { |match| match.score_a.to_i + match.score_b.to_i }
    @venue_average_goals = @venue_completed_matches.any? ? (@venue_total_goals.to_f / @venue_completed_matches.size).round(1) : 0.0
    @venue_next_match = @venue_pending_matches.find { |match| match.scheduled_on.blank? || match.scheduled_on >= Date.current } || @venue_pending_matches.first
    @venue_schedule_groups = @venue_matches.group_by { |match| match.scheduled_on || Date.new(9999, 12, 31) }.sort_by(&:first).map do |scheduled_on, matches|
      {
        scheduled_on: scheduled_on == Date.new(9999, 12, 31) ? nil : scheduled_on,
        matches: matches.sort_by { |match| [match.scheduled_time.to_s, match.code.to_s, match.id] }
      }
    end
    @venue_goal_chart = @venue_completed_matches.last(6).map do |match|
      {
        label: match.code,
        subtitle: [match.scheduled_on&.strftime("%d/%m"), match.team_a&.name, match.team_b&.name].compact.join(" · "),
        value: match.score_a.to_i + match.score_b.to_i
      }
    end
    @venue_month_chart = last_months.map do |month|
      {
        label: month.strftime("%m/%y"),
        value: @venue_matches.count { |match| match.scheduled_on&.beginning_of_month == month }
      }
    end
    @venue_status_breakdown = Match.statuses.keys.index_with { |status| @venue_matches.count { |match| match.status == status } }
  end

  def last_months
    current_month = Date.current.beginning_of_month
    5.downto(0).map { |offset| current_month - offset.months }
  end
end
