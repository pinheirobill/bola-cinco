class ActiveChampionshipsController < ApplicationController
  def show
    championship = current_championship
    render json: championship ? championship.as_json(only: %i[id name season status]) : { championship: nil }
  end

  def create
    championship = Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
    return forbidden! unless championship.visible_by?(current_user)

    set_current_championship(championship)
    render json: championship.as_json(only: %i[id name season status])
  end

  def destroy
    session.delete(:championship_id)
    head :no_content
  end
end
