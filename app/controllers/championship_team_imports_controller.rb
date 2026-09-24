class ChampionshipTeamImportsController < ApplicationController
  before_action :load_championship
  before_action :require_manageability

  def new
    @categories = @championship.categories.order(:name)
    @category = @categories.first
  end

  def create
    @categories = @championship.categories.order(:name)
    @category = @categories.find_by(id: params.dig(:team_import, :category_id)) || @categories.first
    raise ActiveRecord::RecordNotFound if @category.blank?

    rows = BolaCinco::TeamRosterSpreadsheet.read(params.dig(:team_import, :file))
    result = BolaCinco::TeamRosterImport.new(championship: @championship, category: @category, rows: rows).call
    created_teams = result.count { |entry| entry[:action] == "create" }
    reused_teams = result.count { |entry| entry[:action] == "reuse" }
    reused_athletes = result.sum { |entry| entry[:reused_athletes].to_i }

    redirect_to championship_path(@championship),
      notice: "#{created_teams} equipe#{'s' if created_teams != 1} importada#{'s' if created_teams != 1}. #{reused_teams} já existia#{'m' if reused_teams != 1}. #{reused_athletes} atleta#{'s' if reused_athletes != 1} reaproveitado#{'s' if reused_athletes != 1}."
  rescue BolaCinco::TeamRosterSpreadsheet::InvalidFile, BolaCinco::TeamRosterImport::InvalidImport => error
    @categories ||= @championship.categories.order(:name)
    flash.now[:alert] = error.message
    render :new, status: :unprocessable_entity
  end

  private

  def load_championship
    identifier = params[:championship_id].to_s
    @championship = Championship.find_by(slug: identifier) || Championship.find_by(id: identifier) || raise(ActiveRecord::RecordNotFound)
  end

  def require_manageability
    return forbidden! unless @championship.manageable_by?(current_user)
  end
end
