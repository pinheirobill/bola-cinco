class ChampionshipsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @championships = if user_signed_in?
      current_user.admin? ? Championship.order(season: :desc, created_at: :desc).includes(:categories) : current_user.accessible_championships.order(season: :desc, created_at: :desc).includes(:categories)
    else
      Championship.publicly_visible.order(season: :desc, created_at: :desc).includes(:categories)
    end
  end

  def new
    return forbidden! unless current_user&.admin?

    @championship = Championship.new
    @championship.season ||= Time.zone.today.year
    @championship.status ||= :rascunho
  end

  def create
    return forbidden! unless current_user&.admin?

    @championship = Championship.new(championship_params)
    @championship.status = :rascunho

    if @championship.save
      set_current_championship(@championship)
      redirect_to setup_championship_path(@championship, step: "data"), notice: "Campeonato criado."
    else
      render :new, status: :unprocessable_entity
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

    Rails.logger.info(
      "[championships#update] id=#{@championship.id} autosave=#{autosave_request?} " \
      "step=#{params[:step].presence || 'data'} format=#{(params.dig(:championship, :format)&.to_unsafe_h || {}).inspect} " \
      "scoring=#{(params.dig(:championship, :scoring)&.to_unsafe_h || {}).inspect}"
    )

    if @championship.update(championship_params)
      Rails.logger.info(
        "[championships#update] persisted id=#{@championship.id} " \
        "format=#{@championship.format.inspect} scoring=#{@championship.scoring.inspect}"
      )

      return head :no_content if autosave_request?

      redirect_to setup_championship_path(@championship, step: params[:step].presence || "data"), notice: "Campeonato atualizado."
    else
      Rails.logger.warn(
        "[championships#update] failed id=#{@championship.id} errors=#{@championship.errors.full_messages.join(' | ')} " \
        "format=#{@championship.format.inspect} scoring=#{@championship.scoring.inspect}"
      )

      load_championship_setup
      @step = params[:step].presence_in(%w[data format registrations teams]) || "data"
      return head :unprocessable_entity if autosave_request?

      render :setup, status: :unprocessable_entity
    end
  end

  def finalize_onboarding
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    @championship.update!(status: :em_andamento)
    redirect_to championship_path(@championship), notice: "Onboarding concluído."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def finalize_registrations
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    created_matches = @championship.finalize_registrations!

    redirect_to championship_path(@championship), notice: "Inscrições finalizadas. #{created_matches.size} jogos gerados."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to championship_path(@championship), alert: e.record.errors.full_messages.join(" · ")
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

    category = @championship.categories.find(params[:category_id])
    team_ids = Array(params[:team_ids].presence || params[:team_id]).compact_blank.map(&:to_s)
    raise ActiveRecord::RecordNotFound, "Equipe inválida" if team_ids.blank?

    available_teams = Team.includes(:entity, :category).where.not(category_id: @championship.categories.select(:id))
    teams = available_teams.where(id: team_ids).to_a
    raise ActiveRecord::RecordNotFound, "Equipe inválida" if teams.size != team_ids.size

    Team.transaction do
      teams.each { |team| team.update!(category: category) }
    end

    redirect_to setup_championship_path(@championship, step: "teams"), notice: "#{teams.size} equipes vinculadas à categoria #{category.name}."
  rescue ActiveRecord::RecordNotFound
    redirect_to setup_championship_path(@championship, step: "teams"), alert: "Equipe ou categoria inválida."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to setup_championship_path(@championship, step: "teams"), alert: e.record.errors.full_messages.join(" · ")
  end

  def confirm_all_team_registrations
    @championship = championship_lookup
    return forbidden! unless current_user&.admin?

    pending_teams = @championship.categories.includes(:teams).flat_map(&:teams).select(&:registration_status_pendente?)
    pending_teams.each(&:approve!)

    redirect_back fallback_location: championship_path(@championship), notice: "#{pending_teams.size} inscrições confirmadas."
  end

  def attach_partner
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    source_partner = Partner.find(params[:partner_id])
    record = @championship.partners.new(
      category: source_partner.category,
      name: source_partner.name,
      tier: source_partner.tier,
      status: :ativo,
      logo_url: source_partner.logo_url,
      website_url: source_partner.website_url,
      highlight: true,
      notes: source_partner.notes,
      source_data: source_partner.source_data.deep_dup
    )
    record.source_id = "partner-#{SecureRandom.hex(4)}"
    record.save!

    redirect_back fallback_location: championship_path(@championship), notice: "Parceiro adicionado ao campeonato."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: championship_path(@championship), alert: "Parceiro inválido."
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: championship_path(@championship), alert: e.record.errors.full_messages.join(" · ")
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
    @top_scorers = @championship.top_scorers(5)
    @best_defense_row = @championship.best_defense_row
    @worst_defense_row = @championship.worst_defense_row
    @top_athletes = @championship.top_athletes(5)
    @featured_partners = @championship.featured_partners(5)
    @championship_partners = @championship.partners.includes(:category).order(highlight: :desc, tier: :asc, created_at: :desc)
    @available_partners_to_link = Partner.includes(:championship, :category).where.not(championship_id: @championship.id).status_ativo.order(:name)
    @standing_groups = @championship.standing_groups
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
    @top_scorers = @championship.top_scorers(5)
    @best_defense_row = @championship.best_defense_row
    @worst_defense_row = @championship.worst_defense_row
    @top_athletes = @championship.top_athletes(5)
    @featured_partners = @championship.featured_partners(5)
    @standing_groups = @championship.standing_groups
    @initial_knockout_matches = @championship.matches.includes(:category, :team_a, :team_b).where(phase: "mata_mata", round_number: 1).order(:category_id, :id)
    @initial_knockout_matches_by_category = @initial_knockout_matches.group_by(&:category)
  end

  def championship_params
    params.expect(championship: [
      :source_id,
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
          :matchesPerOpponent,
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
