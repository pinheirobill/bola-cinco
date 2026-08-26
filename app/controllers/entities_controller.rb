class EntitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @entities = scoped_entities.includes(teams: :category).order(:name)
  end

  def show
    @entity = scoped_entities.includes(teams: %i[category athletes], invoices: %i[championship category]).find(params[:id])
  end

  private

  def scoped_entities
    return Entity.includes(teams: :category) if current_user&.admin?
    return Entity.joins(teams: { category: :championships }).where(championships: { id: current_championship.id }).distinct if current_championship.present?

    Entity.none
  end
end
