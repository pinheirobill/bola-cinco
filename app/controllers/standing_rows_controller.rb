class StandingRowsController < ApplicationController
  def index
    @standings_by_category = StandingRow.includes(:category, :team, :championship).order(:category_id, position: :asc, points: :desc, goal_diff: :desc)
  end
end
