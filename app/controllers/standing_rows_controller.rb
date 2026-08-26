class StandingRowsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @standings_by_category = scoped_standing_rows.includes(:category, :team, :championship).order(:category_id, position: :asc, points: :desc, goal_diff: :desc)
  end

  private

  def scoped_standing_rows
    return StandingRow.includes(:category, :team, :championship) if current_user&.admin?
    return StandingRow.where(championship_id: current_championship.id) if current_championship.present?

    StandingRow.none
  end
end
