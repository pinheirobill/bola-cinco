class DashboardController < ApplicationController
  def index
    @championships = Championship.order(season: :desc, created_at: :desc)
    @accessible_championships = if user_signed_in? && !current_user.admin?
      current_user.accessible_championships.order(season: :desc, created_at: :desc)
    else
      @championships
    end
    @championship = current_championship
    @categories = @championship&.categories&.includes(:teams).to_a || []
    @recent_matches = Match.includes(:category, :team_a, :team_b).order(scheduled_on: :desc, id: :desc).limit(8)
    @upcoming_matches = Match.includes(:category, :team_a, :team_b).where(status: %w[agendado em_andamento]).order(scheduled_on: :asc, id: :asc).limit(8)
    @top_standings = StandingRow.includes(:category, :team).order(points: :desc, goal_diff: :desc, goals_for: :desc).limit(8)
  end
end
