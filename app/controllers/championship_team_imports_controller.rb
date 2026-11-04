class ChampionshipTeamImportsController < ApplicationController
  before_action :load_championship
  before_action :load_target_team
  before_action :require_manageability

  def new
    @categories = @championship.categories.order(:name)
    @category = @target_team&.category || @categories.find_by(id: params[:category_id]) || @categories.first
    @return_to_category = params[:return_to_category] == "1"
  end

  def create
    @categories = @championship.categories.order(:name)
    @category = @target_team&.category || @categories.find_by(id: params.dig(:team_import, :category_id)) || @categories.first
    raise ActiveRecord::RecordNotFound if @category.blank?
    @return_to_category = params.dig(:team_import, :return_to_category) == "1"

    rows = BolaCinco::TeamRosterSpreadsheet.read(params.dig(:team_import, :file), require_team: @target_team.blank?)
    athlete_limit = current_user.admin? ? nil : @championship.max_athletes_per_team
    result = BolaCinco::TeamRosterImport.new(championship: @championship, category: @category, rows: rows, target_team: @target_team).call(max_athletes_per_team: athlete_limit)
    created_teams = result.count { |entry| entry[:action] == "create" }
    reused_teams = result.count { |entry| entry[:action] == "reuse" }
    reused_athletes = result.sum { |entry| entry[:reused_athletes].to_i }

    created_athletes = result.sum { |entry| entry[:created_athletes].to_i }
    redirect_path = if @target_team.present?
      team_path(@target_team)
    elsif @return_to_category
      category_path(@category)
    else
      championship_path(@championship)
    end
    notice = if @target_team.present?
      "#{created_athletes} atleta#{'s' if created_athletes != 1} importado#{'s' if created_athletes != 1}. #{reused_athletes} já cadastrado#{'s' if reused_athletes != 1}."
    else
      "#{created_teams} equipe#{'s' if created_teams != 1} importada#{'s' if created_teams != 1}. #{reused_teams} já existia#{'m' if reused_teams != 1}. #{reused_athletes} atleta#{'s' if reused_athletes != 1} reaproveitado#{'s' if reused_athletes != 1}."
    end
    redirect_to redirect_path,
      notice: notice
  rescue BolaCinco::TeamRosterSpreadsheet::InvalidFile, BolaCinco::TeamRosterImport::InvalidImport => error
    @categories ||= @championship.categories.order(:name)
    @return_to_category ||= params.dig(:team_import, :return_to_category) == "1"
    flash.now[:alert] = error.message
    render :new, status: :unprocessable_entity
  end

  private

  def load_championship
    identifier = params[:championship_id].to_s
    @championship = Championship.find_by(slug: identifier) || Championship.find_by(id: identifier) || raise(ActiveRecord::RecordNotFound)
  end

  def require_manageability
    manageable = if @target_team.present?
      @target_team.manageable_by?(current_user) && (current_user.admin? || (@championship.athlete_registration_open? && !@championship.athlete_limit_reached_for?(@target_team)))
    else
      @championship.manageable_by?(current_user)
    end
    return forbidden! unless manageable
  end

  def load_target_team
    team_id = params[:team_id] || params.dig(:team_import, :team_id)
    @target_team = scoped_championship_teams.find(team_id) if team_id.present?
  end

  def scoped_championship_teams
    Team.for_championship(@championship)
  end
end
