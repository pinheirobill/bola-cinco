class ChampionshipsController < ApplicationController
  def index
    @championships = Championship.order(season: :desc, created_at: :desc).includes(:categories)
  end

  def show
    @championship = Championship.includes(categories: :teams, matches: %i[team_a team_b winner], standing_rows: :team).find(params[:id])
    @step = params[:step].presence_in(%w[data format teams]) || "data"
    @available_teams_by_category = Team.includes(:entity, :category).where(category: @championship.categories).order(:name).group_by(&:category_id)
    @recent_matches = @championship.recent_matches(8)
    @standings_by_category = @championship.standings_by_category
    @top_scorers = @championship.top_scorers(5)
    @best_defense_row = @championship.best_defense_row
    @worst_defense_row = @championship.worst_defense_row
  end

  def update
    @championship = Championship.find(params[:id])

    if @championship.update(championship_params)
      redirect_to championship_path(@championship, step: params[:step].presence || "data"), notice: "Campeonato atualizado."
    else
      @step = params[:step].presence_in(%w[data format teams]) || "data"
      @available_teams_by_category = Team.includes(:entity, :category).where(category: @championship.categories).order(:name).group_by(&:category_id)
      @recent_matches = @championship.recent_matches(8)
      @standings_by_category = @championship.standings_by_category
      @top_scorers = @championship.top_scorers(5)
      @best_defense_row = @championship.best_defense_row
      @worst_defense_row = @championship.worst_defense_row
      render :show, status: :unprocessable_entity
    end
  end

  private

  def championship_params
    params.expect(championship: [
      :name,
      :season,
      :status,
      :start_date,
      :end_date,
      :registration_start,
      :registration_end,
      :notes,
      { rules: {},
        scoring: [
          :win,
          :draw,
          :loss,
          :wo,
          :woScore,
          :qualifiedPerGroup,
          { tiebreakers: [] }
        ],
        format: [
          :mode,
          :teamCount,
          :groupCount
        ] }
    ])
  end
end
