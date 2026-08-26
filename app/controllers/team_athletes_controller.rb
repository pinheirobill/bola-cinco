class TeamAthletesController < ApplicationController
  def create
    return forbidden! unless scoped_team.manageable_by?(current_user)

    created = []
    skipped = []

    selected_athlete_ids.each do |athlete_id|
      athlete = Athlete.ativos.find(athlete_id)

      if scoped_team.team_athletes.exists?(athlete_id: athlete.id)
        skipped << athlete
        next
      end

      record = scoped_team.team_athletes.new(athlete: athlete, source_id: default_source_id("team-athlete"))

      if record.save
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
      redirect_to team_path(scoped_team), alert: "Selecione ao menos um atleta ativo para vincular."
    end
  end

  def destroy
    return forbidden! unless scoped_team.manageable_by?(current_user)

    scoped_team.team_athletes.find(params[:id]).destroy!
    redirect_to team_path(scoped_team), notice: "Atleta removido da equipe."
  end

  private

  def scoped_team
    @scoped_team ||= Team.find(params[:team_id])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
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
