class AthleteTeamLinksController < ApplicationController
  def create
    return forbidden! unless athlete.manageable_by?(current_user)

    team = available_teams.find(params.expect(team_link: [:team_id])[:team_id])
    record = athlete.team_athletes.new(team: team, source_id: default_source_id("team-athlete"))

    if record.save
      redirect_to athlete_path(athlete), notice: "Equipe vinculada ao atleta."
    else
      redirect_to athlete_path(athlete), alert: record.errors.full_messages.to_sentence
    end
  end

  def destroy
    return forbidden! unless athlete.manageable_by?(current_user)

    link = athlete.team_athletes.find(params[:id])
    if link.team_id == athlete.team_id
      redirect_to athlete_path(athlete), alert: "A equipe principal não pode ser removida por aqui."
    else
      link.destroy!
      redirect_to athlete_path(athlete), notice: "Equipe removida do atleta."
    end
  end

  private

  def athlete
    @athlete ||= Athlete.find(params[:athlete_id])
  end

  def available_teams
    Team.includes(:entity, :category).order(:name)
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
