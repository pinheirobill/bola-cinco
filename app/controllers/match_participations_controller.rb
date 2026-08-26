class MatchParticipationsController < ApplicationController
  def create
    if batch_selected_athlete_ids.any?
      create_participations_from_selection
    else
      record = find_or_build_match_participation
      save_match_participation(record, notice: "Participação registrada.")
    end
  end

  def update
    record = match_participation
    record.assign_attributes(match_participation_params)
    save_match_participation(record, notice: "Participação atualizada.")
  end

  def destroy
    match_participation.destroy!
    redirect_to return_path(match_participation.match), notice: "Participação removida."
  end

  private

  def match
    @match ||= Match.find(params[:match_id])
  end

  def match_participation
    @match_participation ||= MatchParticipation.find(params[:id])
  end

  def match_participation_params
    params.expect(match_participation: [
      :source_id,
      :team_id,
      :athlete_id,
      { athlete_ids: [] },
      :athlete_name,
      :shirt_number,
      :position,
      :status,
      :notes
    ])
  end

  def return_path(match_record)
    params[:return_to].presence || match_path(match_record)
  end

  def scoped_athlete(record)
    team = scoped_teams.detect { |candidate| candidate.id == record.team_id.to_i }
    return if team.blank? || record.athlete_id.blank?

    team.athletes.find_by(id: record.athlete_id)
  end

  def scoped_teams
    [match.team_a, match.team_b].compact
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def batch_selected_athlete_ids
    Array(match_participation_params[:athlete_ids]).flatten.compact_blank
  end

  def create_participations_from_selection
    team = scoped_teams.detect { |candidate| candidate.id == match_participation_params[:team_id].to_i }

    if team.blank?
      load_match_participation_context(match)
      @match_participation = match.match_participations.new(status: :pendente)
      @match_participation.errors.add(:team_id, "selecione uma equipe")
      render "matches/edit", status: :unprocessable_entity
      return
    end

    created = 0
    skipped = 0

    batch_selected_athlete_ids.each do |athlete_id|
      athlete = Athlete.find_by(id: athlete_id)
      next if athlete.blank?

      record = match.match_participations.find_or_initialize_by(team_id: team.id, athlete_id: athlete.id)
      if record.persisted?
        skipped += 1
        next
      end

      record.source_id = default_source_id("match-participation")
      record.team = team
      record.athlete = athlete
      record.status = :pendente

      if record.save
        created += 1
      else
        skipped += 1
      end
    end

    if created.positive?
      message = "#{created} #{created == 1 ? 'participação registrada' : 'participações registradas'}."
      message += " #{skipped} já existiam." if skipped.positive?
      redirect_to return_path(match), notice: message
    elsif skipped.positive?
      redirect_to return_path(match), notice: "As participações selecionadas já existiam."
    else
      redirect_to return_path(match), alert: "Selecione ao menos um atleta."
    end
  end

  def find_or_build_match_participation
    if match_participation_params[:athlete_id].present?
      match.match_participations.find_or_initialize_by(
        team_id: match_participation_params[:team_id],
        athlete_id: match_participation_params[:athlete_id]
      )
    else
      match.match_participations.new
    end
  end

  def save_match_participation(record, notice:)
    record.source_id = default_source_id("match-participation") if record.source_id.blank?
    record.assign_attributes(match_participation_params)
    record.team ||= scoped_teams.detect { |candidate| candidate.id == record.team_id.to_i }
    record.athlete = scoped_athlete(record) if record.athlete_id.present?

    if record.save
      redirect_to return_path(record.match), notice: notice
    else
      load_match_participation_context(match)
      @match_participation = record
      render "matches/edit", status: :unprocessable_entity
    end
  end

  def load_match_participation_context(match_record)
    @match = match_record
    @match_report = @match.match_report || @match.build_match_report(status: :rascunho, source_id: "report-#{@match.source_id}")
    @match_event = @match.match_events.new(kind: :gol)
    @match_participation = @match.match_participations.new(status: :pendente)
    @available_referees = @match.championship.referees.order(:name)
    @available_athletes = @match.roster_athletes
    @available_participation_athletes = Athlete.for_picker
    @available_teams = [@match.team_a, @match.team_b].compact.uniq
    @available_venues = @match.championship.venues.order(:name)
    @match_events = @match.match_events.includes(:team, :athlete).order(created_at: :desc)
    @match_participations = @match.match_participations.includes(:team, :athlete).order(created_at: :desc)
    @team_a_athletes = @match.team_a&.athletes&.includes(:team)&.order(:shirt_number, :name) || Athlete.none
    @team_b_athletes = @match.team_b&.athletes&.includes(:team)&.order(:shirt_number, :name) || Athlete.none
    @team_a_participations = @match_participations.select { |participation| participation.team_id == @match.team_a_id }
    @team_b_participations = @match_participations.select { |participation| participation.team_id == @match.team_b_id }
    @team_a_participations_by_athlete = @team_a_participations.index_by(&:athlete_id)
    @team_b_participations_by_athlete = @team_b_participations.index_by(&:athlete_id)
  end
end
