class TeamsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @teams = scoped_teams.includes(:entity, :category, :athletes).order(:name)
  end

  def show
    @team = scoped_teams.includes(:entity, category: :championships, athletes: [], team_athletes: :athlete, home_matches: %i[category team_a team_b winner], away_matches: %i[category team_a team_b winner], standing_rows: :championship).find(params[:id])
    @team_athletes = @team.team_athletes.includes(athlete: :linked_teams).order(created_at: :desc)
    @team_athlete_ids = @team.athletes.map(&:id)
    @available_athletes = available_athletes_for(@team).sort_by do |athlete|
      [athlete.team.name.to_s.downcase, athlete.shirt_number_sort_key, athlete.quick_label.downcase, athlete.name.downcase]
    end
    @available_teams = Team.includes(:category).order(:name)
    @team_championships = @team.category.championships.order(season: :desc, created_at: :desc)
  end

  def create
    category = Category.find(team_params[:category_id])
    championship = current_championship || category.championship || category.championships.first
    return forbidden! if championship.blank?
    return forbidden! unless current_user.admin? || championship.team_signup_open?

    record = Team.new(team_params)
    record.source_id = default_source_id("team") if record.source_id.blank?

    if record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return forbidden! unless team.manageable_by?(current_user)

    if team.update(team_params)
      respond_to do |format|
        format.html { redirect_back fallback_location: team_path(team), notice: "Equipe atualizada." }
        format.json { render json: team }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: team_path(team), alert: team.errors.full_messages.to_sentence }
        format.json { render json: { errors: team.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def confirm_registration
    return forbidden! unless current_user&.admin?

    team.approve!
    redirect_back fallback_location: team_path(team), notice: "Inscrição confirmada."
  end

  def reject_registration
    return forbidden! unless current_user&.admin?

    team.reject!
    redirect_back fallback_location: team_path(team), notice: "Inscrição rejeitada."
  end

  def destroy
    return forbidden! unless team.manageable_by?(current_user)

    team.destroy!
    head :no_content
  end

  private

  def scoped_teams
    return Team.includes(:entity, :category, :athletes) if current_user&.admin?
    return Team.for_championship(current_championship).includes(:entity, :category, :athletes) if current_championship.present?

    Team.none
  end

  def team
    @team ||= Team.find(params[:id])
  end

  def available_athletes_for(team)
    Athlete.for_picker
  end

  def team_params
    params.expect(team: [
      :source_id,
      :entity_id,
      :category_id,
      :name,
      :short_name,
      :registration_status,
      :finance_status,
      :group_key
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
