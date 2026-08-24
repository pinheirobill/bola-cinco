class MatchesController < ApplicationController
  def index
    @matches = Match.includes(:championship, :category, :team_a, :team_b, :winner).order(scheduled_on: :asc, id: :asc)
  end

  def show
    @match = Match.includes(:championship, :category, :team_a, :team_b, :winner).find(params[:id])
  end
end
