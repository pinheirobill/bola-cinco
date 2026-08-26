class MatchesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @matches = scoped_matches.includes(:championship, :category, :team_a, :team_b, :winner).order(scheduled_on: :asc, id: :asc)
  end

  def show
    load_match_context
  end

  def edit
    load_match_context
  end

  def update
    @match = scoped_matches.find(params[:id])
    @match_report = @match.match_report || @match.build_match_report(status: :rascunho, source_id: "report-#{@match.source_id}")

    ActiveRecord::Base.transaction do
      @match.update!(match_params)
      if match_report_form_params.present?
        @match_report.assign_attributes(match_report_form_params)
        @match_report.source_id ||= "report-#{@match.source_id}"
        @match_report.status = :rascunho
        @match_report.submitted_at = Time.current
        @match_report.approved_at = nil
        @match_report.save!
      end
      @match.sync_auto_goal_events!(**goal_minutes_params)
      @match.sync_competition_state!
    end

    return head :no_content if autosave_request?

    redirect_to match_path(@match), notice: "Jogo atualizado."
  rescue ActiveRecord::RecordInvalid
    load_match_context
    return head :unprocessable_entity if autosave_request?

    render :edit, status: :unprocessable_entity
  end

  private

  def scoped_matches
    return Match.includes(:championship, :category, :team_a, :team_b, :winner) if current_user&.admin?
    return Match.where(championship_id: current_championship.id) if current_championship.present?

    Match.none
  end

  def load_match_context
    @match = scoped_matches.includes(:championship, :category, :team_a, :team_b, :winner).find(params[:id])
    @match_report = @match.match_report || @match.build_match_report(status: :rascunho, source_id: "report-#{@match.source_id}")
    @match_event = @match.match_events.new(kind: :gol)
    @match_participation = @match.match_participations.new(status: :pendente)
    @auto_goal_minutes_a, @auto_goal_minutes_b = @match.auto_goal_minutes_by_side.values_at("a", "b")
    @auto_goal_penalties_a, @auto_goal_penalties_b = @match.auto_goal_penalties_by_side.values_at("a", "b")
    @available_referees = @match.championship.referees.order(:name)
    @available_athletes = @match.roster_athletes
    @available_participation_athletes = Athlete.ativos.for_picker
    @available_teams = [@match.team_a, @match.team_b].compact.uniq
    @available_venues = @match.championship.venues.order(:name)
    @match_events = @match.match_events.includes(:team, :athlete).order(created_at: :desc)
    @match_participations = @match.match_participations.includes(:team, :athlete).order(created_at: :desc)
    @team_a_athletes = @match.team_a&.athletes&.includes(:team)&.order(:shirt_number, :name) || Athlete.none
    @team_b_athletes = @match.team_b&.athletes&.includes(:team)&.order(:shirt_number, :name) || Athlete.none
    @team_a_participations = @match_participations.select { |participation| participation.team_id == @match.team_a_id }
    @team_b_participations = @match_participations.select { |participation| participation.team_id == @match.team_b_id }
    @team_a_participations_by_athlete = @team_a_participations.index_by(&:athlete_id)
    @team_b_participations_by_athlete = @team_b_participations.index_by(&:athlete_id)
  end

  def match_params
    params.expect(match: [
      :category_id,
      :team_a_id,
      :team_b_id,
      :venue_id,
      :code,
      :phase,
      :group_key,
      :round_number,
      :scheduled_on,
      :scheduled_time,
      :score_a,
      :score_b,
      :status,
      :decision,
      :wo,
      :penalties_a,
      :penalties_b
    ])
  end

  def match_report_form_params
    params.fetch(:match_report, {}).permit(:referee_id)
  end

  def goal_minutes_params
    params.fetch(:match, {}).permit(goal_minutes_a: [], goal_minutes_b: [], goal_penalties_a: {}, goal_penalties_b: {}).to_h.tap do |data|
      data[:goal_minutes_a] = Array(data[:goal_minutes_a]).flatten
      data[:goal_minutes_b] = Array(data[:goal_minutes_b]).flatten
      data[:goal_penalties_a] = data.fetch(:goal_penalties_a, {}).to_h.sort_by { |key, _| key.to_i }.map { |_, value| value == "1" || value == 1 || value == true }
      data[:goal_penalties_b] = data.fetch(:goal_penalties_b, {}).to_h.sort_by { |key, _| key.to_i }.map { |_, value| value == "1" || value == 1 || value == true }
    end.symbolize_keys
  end
end
