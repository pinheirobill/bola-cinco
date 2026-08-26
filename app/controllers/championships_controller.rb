class ChampionshipsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @championships = if user_signed_in?
      current_user.admin? ? Championship.order(season: :desc, created_at: :desc).includes(:categories) : current_user.accessible_championships.order(season: :desc, created_at: :desc).includes(:categories)
    else
      Championship.publicly_visible.order(season: :desc, created_at: :desc).includes(:categories)
    end
  end

  def show
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?

    load_championship_overview
  end

  def setup
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    load_championship_setup
  end

  def update
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    if @championship.update(championship_params)
      redirect_to setup_championship_path(@championship, step: params[:step].presence || "data"), notice: "Campeonato atualizado."
    else
      load_championship_setup
      @step = params[:step].presence_in(%w[data format registrations teams]) || "data"
      render :setup, status: :unprocessable_entity
    end
  end

  def draw_knockout_round
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)
    return redirect_to setup_championship_path(@championship, step: "teams"), alert: "O sorteio inicial só está disponível em mata-mata." unless @championship.format_data["mode"].to_s == "mata_mata"

    created_matches = @championship.draw_initial_knockout_round!
    redirect_to setup_championship_path(@championship, step: "teams"), notice: "#{created_matches.size} jogos da primeira rodada sorteados."
  end

  def attach_category
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    category = Category.find(params[:category_id])
    @championship.categories << category unless @championship.categories.exists?(category.id)

    redirect_to setup_championship_path(@championship, step: "teams"), notice: "Categoria vinculada ao campeonato."
  rescue ActiveRecord::RecordNotFound
    redirect_to setup_championship_path(@championship, step: "teams"), alert: "Categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def detach_category
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    category = @championship.categories.find(params[:category_id])
    @championship.championship_categories.find_by!(category_id: category.id).destroy!

    redirect_to setup_championship_path(@championship, step: "teams"), notice: "Categoria removida do campeonato."
  rescue ActiveRecord::RecordNotFound
    redirect_to setup_championship_path(@championship, step: "teams"), alert: "Categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def attach_team
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    team = Team.find(params[:team_id])
    category = @championship.categories.find(params[:category_id])
    team.update!(category: category)

    redirect_to setup_championship_path(@championship, step: "teams"), notice: "Equipe vinculada ao campeonato."
  rescue ActiveRecord::RecordNotFound
    redirect_to setup_championship_path(@championship, step: "teams"), alert: "Equipe ou categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  private

  def championship_lookup
    Championship.find_by(slug: params[:id]) || Championship.find(params[:id])
  end

  def load_championship_overview
    @championship = Championship.includes(
      categories: %i[teams championships],
      matches: %i[team_a team_b winner],
      standing_rows: :team,
      partners: :category
    ).find(@championship.id)
    @available_teams = Team.includes(:entity, :category).order(:name)
    @recent_matches = @championship.recent_matches(8)
    @standings_by_category = @championship.standings_by_category
    @top_scorers = @championship.top_scorers(5)
    @best_defense_row = @championship.best_defense_row
    @worst_defense_row = @championship.worst_defense_row
    @top_athletes = @championship.top_athletes(5)
    @featured_partners = @championship.featured_partners(5)
  end

  def load_championship_setup
    @championship = Championship.includes(categories: %i[teams championships]).find(@championship.id)
    @step = params[:step].presence_in(%w[data format registrations teams]) || "data"
    @available_teams_by_category = Team.includes(:entity, :category).where(category: @championship.categories).order(:name).group_by(&:category_id)
    @available_teams_to_link = Team.includes(:entity, :category).where.not(category_id: @championship.categories.select(:id)).order(:name)
    @championship_categories = @championship.categories.includes(:championships, :teams).order(:name)
    @available_categories_to_link = Category.includes(:championships, :teams).where.not(id: @championship.categories.select(:id)).order(:name)
    @venues = @championship.venues.order(:name)
    @referees = @championship.referees.order(:name)
    @available_venues = Venue.available.order(:name)
    @available_referees = Referee.available.order(:name)
    @recent_matches = @championship.recent_matches(8)
    @standings_by_category = @championship.standings_by_category
    @top_scorers = @championship.top_scorers(5)
    @best_defense_row = @championship.best_defense_row
    @worst_defense_row = @championship.worst_defense_row
    @top_athletes = @championship.top_athletes(5)
    @featured_partners = @championship.featured_partners(5)
  end

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
