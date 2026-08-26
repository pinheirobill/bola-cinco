class TeamPanelsController < ApplicationController
  def show
    @teams = current_team_panel_teams.order(:name)
    @team = if params[:team_id].present?
      Team.includes(:entity, :category, :athletes, :team_memberships, home_matches: %i[category team_a team_b winner], away_matches: %i[category team_a team_b winner]).find(params[:team_id])
    else
      @teams.first
    end

    return forbidden! unless @team.nil? || current_user.can_view_team?(@team)

    render json: {
      championship: current_championship && {
        id: current_championship.id,
        name: current_championship.name,
        season: current_championship.season,
        status: current_championship.status,
        max_athletes_per_team: current_championship.max_athletes_per_team,
        max_staff_members_per_team: current_championship.max_staff_members_per_team,
        team_signup_enabled: current_championship.team_signup_enabled?,
        printed_summary_field: current_championship.printed_summary_field
      },
      registration: current_championship&.registration_data,
      teams: @teams.as_json(include: %i[entity category athletes]),
      team: @team&.as_json(include: %i[entity category athletes team_memberships])
    }
  end
end
