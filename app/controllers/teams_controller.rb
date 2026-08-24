class TeamsController < ApplicationController
  def index
    @teams = Team.includes(:entity, :category, :athletes).order(:name)
  end

  def show
    @team = Team.includes(:entity, :category, athletes: [], home_matches: %i[category team_a team_b winner], away_matches: %i[category team_a team_b winner], standing_rows: :championship).find(params[:id])
  end
end
