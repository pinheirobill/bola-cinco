class AthletesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show card]

  def index
    @championship = current_championship
    @athletes = scoped_athletes.includes(:team, :category).order(:name)
    @athletes_count = @athletes.size
    @categories_count = @athletes.map(&:category_id).compact.uniq.size
    @teams_count = @athletes.map(&:team_id).compact.uniq.size
    @photo_count = @athletes.count(&:display_photo_url)
    @documents_count = @athletes.count { |athlete| athlete.preferred_document.present? }
    @price_per_athlete = athlete_card_unit_price(@athletes_count)
    @sample_athlete = @athletes.first
  end

  def show
    @athlete = scoped_athletes.includes(team: %i[entity category], linked_teams: :entity, category: %i[championship championships]).find(params[:id])
    @athlete_team_links = @athlete.team_athletes.includes(:team).order(created_at: :desc)
    @available_teams = @athlete.championship&.teams&.where.not(id: @athlete.linked_teams.select(:id)).order(:name) || Team.none
    @championship = @athlete.championship
    @performance_summary = @athlete.performance_summary
    @recent_matches = @athlete.recent_performance_matches
    @recent_events = @athlete.recent_performance_events
    @recent_suspensions = @athlete.recent_performance_suspensions
  end

  def card
    @athlete = scoped_athletes.includes(team: %i[entity category], linked_teams: :entity, category: %i[championship championships]).find(params[:id])
    @performance_summary = @athlete.performance_summary

    respond_to do |format|
      format.html
      format.pdf do
        send_data AthleteCardDocument.new(@athlete).render,
          filename: "#{@athlete.name.parameterize.presence || "carteirinha"}.pdf",
          type: "application/pdf",
          disposition: "attachment"
      end
    end
  end

  def create
    team = Team.find(athlete_params[:team_id])
    championship = current_championship || team.championship || team.category.championship || team.category.championships.first
    return forbidden! unless current_user.admin? || (championship.athlete_registration_open? && current_user.can_manage_team?(team))
    return forbidden! if championship.athlete_limit_reached_for?(team) && !current_user.admin?

    record = Athlete.new(athlete_params)
    record.source_id = default_source_id("athlete") if record.source_id.blank?

    if record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    championship = current_championship || athlete.team.championship || athlete.team.category.championship || athlete.team.category.championships.first
    return forbidden! unless current_user.admin? || (championship.athlete_editing_open? && athlete.manageable_by?(current_user))

    if athlete.update(athlete_params)
      render json: athlete
    else
      render json: { errors: athlete.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    championship = current_championship || athlete.team.championship || athlete.team.category.championship || athlete.team.category.championships.first
    return forbidden! unless current_user.admin? || (championship.athlete_removal_open? && athlete.manageable_by?(current_user))

    athlete.destroy!
    head :no_content
  end

  private

  def scoped_athletes
    return current_championship.athletes if current_championship.present?
    return Athlete.includes(:team, :category) if current_user&.admin?

    Athlete.none
  end

  def athlete
    @athlete ||= Athlete.find(params[:id])
  end

  def athlete_params
    params.expect(athlete: [
      :source_id,
      :team_id,
      :category_id,
      :user_id,
      :name,
      :birth_date,
      :shirt_number,
      :document,
      :photo_url,
      :cpf,
      :rg,
      :birth_certificate,
      :position,
      :cell_phone,
      :email,
      :passport,
      :voter_id,
      :gender,
      :documents_count,
      :registration_submitted_at,
      :status
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def athlete_card_unit_price(count)
    return 1.0 if count <= 200
    return 0.7 if count <= 500

    0.5
  end
end
