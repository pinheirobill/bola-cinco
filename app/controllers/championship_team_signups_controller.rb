class ChampionshipTeamSignupsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    load_championship
    return forbidden! unless @championship.publicly_visible? && @championship.team_signup_open?

    @categories = @championship.categories.order(:name)
    @entity = Entity.new
    @team = Team.new
  end

  def create
    load_championship
    return forbidden! unless @championship.publicly_visible? && @championship.team_signup_open?

    @categories = @championship.categories.order(:name)
    entity = Entity.new(entity_params)
    team = Team.new(team_params)
    team.entity = entity
    team.source_id = default_source_id("team") if team.source_id.blank?
    entity.source_id = default_source_id("entity") if entity.source_id.blank?

    if team_params[:category_id].blank?
      team.errors.add(:category, "obrigatória")
    else
      team.category = @categories.find_by(id: team_params[:category_id])
      team.errors.add(:category, "inválida") if team.category.nil?
    end

    if team.errors.empty?
      ActiveRecord::Base.transaction do
        entity.save!
        team.save!
      end
    else
      raise ActiveRecord::RecordInvalid.new(team)
    end

    redirect_to championship_path(@championship), notice: "Time inscrito com sucesso."
  rescue ActiveRecord::RecordInvalid
    @entity = entity
    @team = team
    render :new, status: :unprocessable_entity
  end

  private

  def load_championship
    @championship = Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
  end

  def entity_params
    params.expect(entity: [
      :source_id,
      :name,
      :responsible,
      :phone,
      :whatsapp,
      :email,
      :city,
      :notes
    ])
  end

  def team_params
    params.expect(team: [
      :source_id,
      :category_id,
      :name,
      :short_name
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
