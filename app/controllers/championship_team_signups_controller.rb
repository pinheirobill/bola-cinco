class ChampionshipTeamSignupsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    load_championship
    return forbidden! unless @championship.team_signup_open?

    @teams = signup_teams
    @featured_teams = @teams.limit(6)
    @category = default_signup_category
    @categories = signup_categories
    @team = Team.new
    @signup_mode = @teams.any? ? "existing" : "new"
    @signup_subject = @championship.tranca? ? "duplas" : "equipes"
    @signup_title = @championship.tranca? ? "Inscrição de duplas" : "Inscrição de equipes"
    @signup_intro = if @championship.tranca?
      "Escolha uma dupla já cadastrada ou crie uma nova. A entidade pode ser criada automaticamente com o nome da dupla."
    else
      "Selecione uma equipe já cadastrada ou crie uma nova para vinculá-la ao campeonato."
    end
  end

  def create
    load_championship
    return forbidden! unless @championship.team_signup_open?

    if params[:visit_only].present?
      @championship.record_public_signup_visit!
      return head :no_content
    end

    @teams = signup_teams
    @featured_teams = @teams.limit(6)
    @category = default_signup_category
    @categories = signup_categories
    team_signup = team_signup_params
    @signup_mode = team_signup[:signup_mode].presence_in(%w[existing new]) || (team_signup[:team_id].present? ? "existing" : "new")
    @signup_subject = @championship.tranca? ? "duplas" : "equipes"
    @signup_title = @championship.tranca? ? "Inscrição de duplas" : "Inscrição de equipes"
    @signup_intro = if @championship.tranca?
      "Escolha uma dupla já cadastrada ou crie uma nova. A entidade pode ser criada automaticamente com o nome da dupla."
    else
      "Selecione uma equipe já cadastrada ou crie uma nova para vinculá-la ao campeonato."
    end

    if @signup_mode == "existing"
      team = @teams.find_by(id: team_signup[:team_id])
      @team = team || Team.new

      if team_signup[:team_id].blank?
        @team.errors.add(:team, "obrigatório")
      else
        @team.errors.add(:team, "inválido") if team.nil?
      end
    else
      @team = Team.new(
        name: team_signup[:team_name],
        short_name: team_signup[:short_name]
      )

      @team.errors.add(:entity, "obrigatória") if !@championship.tranca? && team_signup[:entity_name].blank?
      @team.errors.add(:name, "obrigatório") if team_signup[:team_name].blank?
    end

    if @championship.tranca?
      @team.errors.add(:category, "indisponível") if @category.nil?
    else
      @category = @categories.find_by(id: team_signup[:category_id]) if team_signup[:category_id].present?
      @team.errors.add(:category, "obrigatória") if team_signup[:category_id].blank?
      @team.errors.add(:category, "inválida") if team_signup[:category_id].present? && @category.nil?
    end

    if @team.errors.empty?
      if @signup_mode == "existing"
        @team.update!(category: @category, registration_status: :pendente)
        redirect_to championship_path(
          @championship,
          anchor: @championship.tranca? ? "duplas" : nil,
          signup_team: @championship.tranca? ? @team.source_id : nil
        ), notice: @championship.tranca? ? "Dupla selecionada com sucesso." : "Time selecionado com sucesso."
      else
        create_public_team!
      end
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
      :signup_mode,
      :team_id,
      :category_id,
      :entity_name,
      :team_name,
      :short_name
    ])
  end

  def create_public_team!
    Entity.transaction do
      entity_name = team_signup_params[:entity_name].presence || @team.name
      entity = Entity.create!(
        source_id: default_source_id("entity"),
        name: entity_name
      )

      @team.entity = entity
      @team.category = @category
      @team.source_id = default_source_id("team")
      @team.registration_status = :pendente

      if @team.save
        redirect_to championship_path(
          @championship,
          anchor: @championship.tranca? ? "duplas" : nil,
          signup_team: @championship.tranca? ? @team.source_id : nil
        ), notice: @championship.tranca? ? "Dupla cadastrada e inscrita com sucesso." : "Equipe cadastrada e inscrita com sucesso."
      else
        raise ActiveRecord::Rollback
      end
    end

    render :new, status: :unprocessable_entity if @team.errors.any?
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def signup_teams
    if @championship.tranca?
      Team.for_championship(@championship).includes(:entity, :category).order(:name)
    else
      Team.includes(:entity, :category).order(:name)
    end
  end

  def signup_categories
    return [@category].compact if @championship.tranca? && @category.present?

    @championship.categories.order(:name)
  end

  def default_signup_category
    return @championship.ensure_tranca_onboarding_category! if @championship.tranca?

    @championship.categories.order(:name).first
  end
end
