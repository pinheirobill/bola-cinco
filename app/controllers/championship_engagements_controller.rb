class ChampionshipEngagementsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    championship = scoped_championship

    render json: {
      championship: championship.as_json(only: %i[id name season status]),
      top_teams: championship.top_teams(5).as_json(include: %i[team category]),
      top_athletes: championship.top_athletes(10).map(&:to_h),
      featured_partners: championship.featured_partners(6).as_json(include: :category)
    }
  end

  private

  def scoped_championship
    @scoped_championship ||= if params[:championship_id].present?
      Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
    else
      current_championship || raise(ActiveRecord::RecordNotFound)
    end
  end
end
