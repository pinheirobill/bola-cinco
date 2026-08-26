class ChampionshipTeamSignupsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    load_championship
    return forbidden! unless @championship.publicly_visible? && @championship.team_signup_open?

    @teams = Team.includes(:entity, :category).order(:name)
    @categories = @championship.categories.order(:name)
    @team = Team.new
  end

  def create
    load_championship
    return forbidden! unless @championship.publicly_visible? && @championship.team_signup_open?

    @teams = Team.includes(:entity, :category).order(:name)
    @categories = @championship.categories.order(:name)
    team_signup = team_signup_params
    team = @teams.find_by(id: team_signup[:team_id])
    @team = team || Team.new

    if team_signup[:team_id].blank?
      @team.errors.add(:team, "obrigatório")
    else
      @team.errors.add(:team, "inválido") if team.nil?
    end

    if team_signup[:category_id].blank?
      @team.errors.add(:category, "obrigatória")
    else
      @category = @categories.find_by(id: team_signup[:category_id])
      @team.errors.add(:category, "inválida") if @category.nil?
    end

    if @team.errors.empty?
      @team.update!(category: @category, registration_status: :pendente)
      redirect_to championship_path(@championship), notice: "Time selecionado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def load_championship
    @championship = Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
  end

  def team_signup_params
    params.expect(team_signup: [
      :team_id,
      :category_id
    ])
  end
end
