class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @categories = scoped_categories.includes(:championship, :teams).order(:name)
  end

  def show
    @category = scoped_categories.includes(:championship, teams: :entity, matches: %i[team_a team_b winner], standing_rows: :team).find(params[:id])
  end

  private

  def scoped_categories
    return Category.includes(:championship, :teams) if current_user&.admin?
    return current_championship.categories if current_championship.present?

    Category.none
  end
end
