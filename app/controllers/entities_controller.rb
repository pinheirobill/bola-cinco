class EntitiesController < ApplicationController
  def index
    @entities = Entity.includes(teams: :category).order(:name)
  end

  def show
    @entity = Entity.includes(teams: %i[category athletes], invoices: %i[championship category]).find(params[:id])
  end
end
