class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @championships = Championship.publicly_visible.order(season: :desc, created_at: :desc).includes(:categories, :matches, :standing_rows)
    @championship = current_championship
    @top_matches = @championship&.recent_matches(4) || []
    @top_teams = @championship&.top_teams(4) || []
    @top_athletes = @championship&.top_athletes(4) || []
    @published_news = @championship&.published_news(3) || []
  end
end
