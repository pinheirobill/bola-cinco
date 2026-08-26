class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @championships = Championship.publicly_visible.order(season: :desc, created_at: :desc).includes(:categories, :matches, :standing_rows)
    @championship = current_championship
    @top_matches = @championship&.recent_matches(4) || []
    @top_teams = @championship&.top_teams(4) || []
    @top_athletes = @championship&.top_athletes(4) || []
    @featured_partners = @championship&.featured_partners(3) || []
    load_internal_dashboard if user_signed_in?
  end

  private

  def load_internal_dashboard
    @accessible_championships = if current_user.admin?
      Championship.order(season: :desc, created_at: :desc)
    else
      current_user.accessible_championships.order(season: :desc, created_at: :desc)
    end
    @internal_championship = @championship
    @internal_categories = @internal_championship&.categories&.includes(:teams).to_a || []
    @recent_matches = Match.includes(:category, :team_a, :team_b).order(scheduled_on: :desc, id: :desc).limit(8)
    @upcoming_matches = Match.includes(:category, :team_a, :team_b).where(status: %w[agendado em_andamento]).order(scheduled_on: :asc, id: :asc).limit(8)
    @top_standings = StandingRow.includes(:category, :team).order(points: :desc, goal_diff: :desc, goals_for: :desc).limit(8)
  end
end
