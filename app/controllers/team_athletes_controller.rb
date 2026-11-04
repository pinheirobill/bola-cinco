class TeamAthletesController < ApplicationController
  def create
    return forbidden! unless scoped_team.manageable_by?(current_user)

    submitted_athlete = params.fetch(:team_athlete, ActionController::Parameters.new)[:athlete]
    if submitted_athlete.present?
      attributes = params.expect(team_athlete: { athlete: [:name, :email] })[:athlete]
      return create_athlete(attributes)
    end

    created = []
    skipped = []

    selected_athlete_ids.each do |athlete_id|
      athlete = Athlete.find(athlete_id)

      if scoped_team.team_athletes.exists?(athlete_id: athlete.id)
        skipped << athlete
        next
      end

      record = scoped_team.team_athletes.new(athlete: athlete, source_id: default_source_id("team-athlete"))

      if record.save
        sync_tranca_dupla_membership_from_team_athlete(record) if scoped_team.championship&.tranca?
        created << athlete
      else
        skipped << athlete
      end
    end

    if created.any?
      message = "#{created.size} atleta#{'s' if created.size > 1} vinculado#{'s' if created.size > 1} à equipe."
      message += " #{skipped.size} já estavam vinculados." if skipped.any?
      redirect_to team_path(scoped_team), notice: message
    else
      redirect_to team_path(scoped_team), alert: "Selecione ao menos um atleta cadastrado para vincular."
    end
  end

  def destroy
    return forbidden! unless scoped_team.manageable_by?(current_user)

    record = scoped_team.team_athletes.find(params[:id])
    source_id = record.source_id
    record.destroy!
    destroy_tranca_dupla_membership_from_source_id(source_id) if scoped_team.championship&.tranca?
    redirect_to team_path(scoped_team), notice: "Atleta removido da equipe."
  end

  private

  def create_athlete(attributes)
    championship = scoped_team.championship || scoped_team.category.championship || scoped_team.category.championships.first
    if !current_user.admin? && (championship.blank? || !championship.athlete_registration_open? || championship.athlete_limit_reached_for?(scoped_team))
      return redirect_to team_path(scoped_team), alert: "O cadastro de atletas está fechado ou a equipe atingiu o limite."
    end

    athlete = Athlete.new(
      source_id: default_source_id("athlete"),
      team: scoped_team,
      category: scoped_team.category,
      name: attributes[:name].to_s.squish,
      email: attributes[:email].to_s.strip.presence,
      status: :pendente,
      registration_submitted_at: Time.current
    )

    if athlete.save
      record = scoped_team.team_athletes.find_or_create_by!(athlete: athlete) do |link|
        link.source_id = "team-athlete-#{scoped_team.id}-#{athlete.id}"
      end
      sync_tranca_dupla_membership_from_team_athlete(record) if scoped_team.championship&.tranca?
      redirect_to team_path(scoped_team), notice: "Atleta cadastrado e vinculado à equipe."
    else
      redirect_to team_path(scoped_team), alert: athlete.errors.full_messages.to_sentence
    end
  end

  def scoped_team
    @scoped_team ||= Team.find(params[:team_id])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def sync_tranca_dupla_membership_from_team_athlete(record)
    tranca_dupla = Tranca::Dupla.find_by(source_id: record.team.source_id)
    return if tranca_dupla.blank?

    membership = Tranca::DuplaMembership.find_or_initialize_by(source_id: record.source_id)
    membership.assign_attributes(
      tranca_dupla: tranca_dupla,
      athlete: record.athlete,
      position: record.position,
      shirt_number: record.shirt_number
    )
    membership.save!
  end

  def destroy_tranca_dupla_membership_from_source_id(source_id)
    Tranca::DuplaMembership.find_by(source_id: source_id)&.destroy!
  end

  def selected_athlete_ids
    params.fetch(:team_athlete, {})
      .permit(:athlete_id, athlete_ids: [])
      .values
      .flatten
      .compact_blank
      .uniq
  end
end
