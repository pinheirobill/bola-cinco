class AthletesController < ApplicationController
  def index
    @athletes = Athlete.includes(:team, :category).order(:name)
  end

  def show
    @athlete = Athlete.includes(team: %i[entity category], category: :championship).find(params[:id])
  end
end
