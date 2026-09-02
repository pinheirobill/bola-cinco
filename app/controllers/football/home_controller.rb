class Football::HomeController < ApplicationController
  skip_before_action :authenticate_user!
  layout "football"

  def index
    @championships = championships_for_modality(:football)
    @championship = @championships.first
    @top_matches = @championship&.recent_matches(4) || []
    @top_teams = @championship&.top_teams(4) || []
    @top_athletes = @championship&.top_athletes(4) || []
  end
end
