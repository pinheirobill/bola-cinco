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
      [ athlete.team.name.to_s.downcase, athlete.shirt_number_sort_key, athlete.quick_label.downcase, athlete.name.downcase ]
    end
    @available_teams = Team.includes(:category).order(:name)
    @team_championships = @team.category.championships.order(season: :desc, created_at: :desc)
    tranca_championship_ids = @team_championships.where(modality: :tranca).select(:id)
    tranca_dupla_ids = Tranca::Dupla.where(championship_id: tranca_championship_ids, source_id: @team.source_id).select(:id)
    @tranca_matches = Tranca::Partida.includes(:category, :dupla_a, :dupla_b, :winner, :tranca_mesa)
      .where(championship_id: tranca_championship_ids)
      .where(dupla_a_id: tranca_dupla_ids)
      .or(
        Tranca::Partida.includes(:category, :dupla_a, :dupla_b, :winner, :tranca_mesa)
          .where(championship_id: tranca_championship_ids)
          .where(dupla_b_id: tranca_dupla_ids)
      )
      .order(scheduled_on: :asc, scheduled_time: :asc, id: :asc)
  end

  def create
    params_data = team_params
    category = Category.find(params_data[:category_id])
    championship = current_championship || category.championship || category.championships.first
    return forbidden! if championship.blank?
    return forbidden! unless current_user.admin? || championship.team_signup_open?

    record = Team.new(
      params_data.except(:entity_id, :participant_one_name, :participant_two_name)
    )

    participant_names = [ params_data[:participant_one_name], params_data[:participant_two_name] ].map { _1.to_s.strip }.reject(&:blank?)
    record_name = record.name.to_s.strip
    record_name = participant_names.join(" / ") if record_name.blank? && participant_names.any?
    if record_name.blank?
      record.errors.add(:name, "obrigatório")
    else
      record.name = record_name
    end

    entity = if params_data[:entity_id].present?
      Entity.find_by(id: params_data[:entity_id]).tap do |found_entity|
        record.errors.add(:entity, "inválida") if found_entity.blank?
      end
    else
      Entity.create!(
        source_id: default_source_id("entity"),
        name: record_name
      ) if record_name.present?
    end

    record.entity = entity
    record.source_id = default_source_id("team") if record.source_id.blank?
    record.registration_status = :pendente if championship.tranca?

    if record.save
      sync_tranca_dupla_from_team(record) if championship.tranca?

      if browser_form_submission?
        redirect_back fallback_location: team_path(record), notice: "Dupla criada."
      else
        render json: record, status: :created
      end
    else
      if browser_form_submission?
        redirect_back fallback_location: teams_path, alert: record.errors.full_messages.to_sentence
      else
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def edit
    return forbidden! unless team.manageable_by?(current_user)

    @team = team
  end

  def update
    return forbidden! unless team.manageable_by?(current_user)

    if team.update(team_params)
      sync_tranca_dupla_from_team(team) if team.championship&.tranca?

      respond_to do |format|
        format.html do
          if params[:edit_team] == "1"
            redirect_to team_path(team), notice: "Equipe atualizada.", status: :see_other
          else
            redirect_back fallback_location: team_path(team), notice: "Equipe atualizada."
          end
        end
        format.json { render json: team }
      end
    else
      respond_to do |format|
        format.html do
          if params[:edit_team] == "1"
            @team = team
            render :edit, status: :unprocessable_entity
          else
            redirect_back fallback_location: team_path(team), alert: team.errors.full_messages.to_sentence
          end
        end
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

    if Athlete.exists?(team_id: team.id)
      return redirect_back fallback_location: team_path(team), status: :see_other,
        alert: "Esta dupla/time é o cadastro principal de atletas. Transfira o cadastro principal deles antes de excluir."
    end

    Team.transaction do
      destroy_tranca_dupla_from_team(team) if team.championship&.tranca?
      team.destroy!
    end
    head :no_content
  rescue ActiveRecord::InvalidForeignKey, ActiveRecord::RecordNotDestroyed
    redirect_back fallback_location: team_path(team), status: :see_other,
      alert: "Não foi possível excluir: existem registros vinculados. Nenhum cadastro foi removido nesta tentativa."
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
      :participant_one_name,
      :participant_two_name,
      :short_name,
      :registration_status,
      :finance_status,
      :group_key
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def browser_form_submission?
    request.format.html? && request.referer.present?
  end

  def sync_tranca_dupla_from_team(team)
    tranca_dupla = Tranca::Dupla.find_or_initialize_by(source_id: team.source_id)
    tranca_dupla.assign_attributes(
      championship: team.championship,
      category: team.category,
      entity: team.entity,
      name: team.name,
      short_name: team.short_name,
      registration_status: team.registration_status
    )
    tranca_dupla.save!
  end

  def destroy_tranca_dupla_from_team(team)
    Tranca::Dupla.find_by(source_id: team.source_id)&.destroy!
  end
end
