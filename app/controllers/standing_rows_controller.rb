class StandingRowsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    grouped_rows = scoped_standing_rows.includes(:category, :team, :championship).order(:category_id, :group_key, position: :asc, points: :desc, goal_diff: :desc)
    @standing_groups = grouped_rows.group_by { |row| [row.category, row.group_key.to_s] }.map do |(category, group_key), rows|
      Championship::StandingGroup.new(category: category, group_key: group_key, rows: rows)
    end.sort_by { |group| [group.category.name.to_s.downcase, group.group_key.to_s.downcase] }
  end

  private

  def scoped_standing_rows
    return StandingRow.includes(:category, :team, :championship) if current_user&.admin?
    return StandingRow.where(championship_id: current_championship.id) if current_championship.present?

    StandingRow.none
  end
end
