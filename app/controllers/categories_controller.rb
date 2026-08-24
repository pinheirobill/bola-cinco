class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:championship, :teams).order(:name)
  end

  def show
    @category = Category.includes(:championship, teams: :entity, matches: %i[team_a team_b winner], standing_rows: :team).find(params[:id])
  end
end
