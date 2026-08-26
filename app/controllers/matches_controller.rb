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
    form_params = match_form_params

    ActiveRecord::Base.transaction do
      @match.update!(match_params)
      @match.sync_event_sheet!(form_params[:event_sheet]) if form_params.key?(:event_sheet)
      if match_report_form_params.present?
        @match_report.assign_attributes(match_report_form_params)
        @match_report.source_id ||= "report-#{@match.source_id}"
        @match_report.status = :rascunho
        @match_report.submitted_at = Time.current
        @match_report.approved_at = nil
        @match_report.save!
      end
      @match.sync_auto_goal_events!(**goal_minutes_params(form_params))
      @match.sync_competition_state!
    end

    if autosave_request?
      load_match_context
      return respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("match-score-card", partial: "matches/score_card", locals: { match: @match }),
            turbo_stream.replace("match-event-summary", partial: "matches/event_summary", locals: {
              match: @match,
              match_events: @match_events
            }),
            turbo_stream.replace("match-event-sheet-team-a", partial: "matches/event_sheet_table", locals: {
              id: "match-event-sheet-team-a",
              title: "Equipe A",
              team: @match.team_a,
              athletes: @team_a_athletes,
              match_events: @match_events
            }),
            turbo_stream.replace("match-event-sheet-team-b", partial: "matches/event_sheet_table", locals: {
              id: "match-event-sheet-team-b",
              title: "Equipe B",
              team: @match.team_b,
              athletes: @team_b_athletes,
              match_events: @match_events
            }),
            turbo_stream.replace("match-auto-goals", partial: "matches/auto_goals", locals: {
              match: @match,
              auto_goal_minutes_a: @auto_goal_minutes_a,
              auto_goal_minutes_b: @auto_goal_minutes_b,
              auto_goal_penalties_a: @auto_goal_penalties_a,
              auto_goal_penalties_b: @auto_goal_penalties_b
            })
          ]
        end
        format.html { redirect_to edit_match_path(@match) }
      end
    end

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
    params.fetch(:match, {}).permit(
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
    )
  end

  def match_form_params
    params.fetch(:match, {}).permit(goal_minutes_a: [], goal_minutes_b: [], goal_penalties_a: {}, goal_penalties_b: {}, event_sheet: {})
  end

  def match_report_form_params
    params.fetch(:match_report, {}).permit(:referee_id)
  end

  def goal_minutes_params(form_params = nil)
    source = (form_params || match_form_params).to_h
    data = source.slice("goal_minutes_a", "goal_minutes_b", "goal_penalties_a", "goal_penalties_b").with_indifferent_access

    data.tap do |data_hash|
      data_hash[:goal_minutes_a] = Array(data_hash[:goal_minutes_a]).flatten
      data_hash[:goal_minutes_b] = Array(data_hash[:goal_minutes_b]).flatten
      data_hash[:goal_penalties_a] = data_hash.fetch(:goal_penalties_a, {}).to_h.sort_by { |key, _| key.to_i }.map { |_, value| value == "1" || value == 1 || value == true }
      data_hash[:goal_penalties_b] = data_hash.fetch(:goal_penalties_b, {}).to_h.sort_by { |key, _| key.to_i }.map { |_, value| value == "1" || value == 1 || value == true }
    end.symbolize_keys
  end
end
