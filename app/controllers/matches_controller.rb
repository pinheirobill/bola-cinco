require "digest"
require "base64"
require "fileutils"

class MatchesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @matches = scoped_matches.includes(:championship, :category, :team_a, :team_b, :winner).order(scheduled_on: :asc, id: :asc)
  end

  def create
    championship = championship_for_write
    return forbidden! if championship.blank?
    return forbidden! unless championship.manageable_by?(current_user)

    category = championship.categories.find(match_params[:category_id])
    record = championship.matches.new(match_params.except(:championship_id).merge(category: category))
    record.source_id = default_source_id("match") if record.source_id.blank?

    if record.save
      record.sync_competition_state! if record.status_finalizado? || record.status_wo?
      sync_tranca_partida_from_match(record) if championship.tranca?

      if browser_form_submission?
        redirect_back fallback_location: match_path(record), notice: "Partida criada."
      else
        render json: record, status: :created
      end
    else
      if browser_form_submission?
        redirect_back fallback_location: matches_path, alert: record.errors.full_messages.to_sentence
      else
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def show
    load_match_context
  end

  def edit
    load_match_context
  end

  def import_summula
    @match = scoped_matches.find(params[:id])

    if params.dig(:match_summula_import, :confirm).present?
      confirm_summula_import
    else
      build_summula_import_preview
    end
  end

  def update
    @match = scoped_matches.find(params[:id])
    @match_report = @match.match_report || @match.build_match_report(status: :rascunho, source_id: "report-#{@match.source_id}")
    form_params = match_form_params

    ActiveRecord::Base.transaction do
      @match.update!(match_params)
      @match.sync_event_sheet!(form_params[:event_sheet]) if form_params.key?(:event_sheet)
      if match_report_form_params.present?
        @match_report.assign_attributes(match_report_form_params)
        @match_report.source_id ||= "report-#{@match.source_id}"
        @match_report.status = :rascunho
        @match_report.submitted_at = Time.current
        @match_report.approved_at = nil
        @match_report.save!
      end
      @match.sync_competition_state!
      sync_tranca_partida_from_match(@match) if @match.championship.tranca?
    end

    if autosave_request?
      load_match_context
      return respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("match-score-card", partial: "matches/score_card", locals: { match: @match }),
            turbo_stream.replace("match-event-editor", partial: "matches/event_sheet_editor", locals: {
              match: @match,
              team_a_athletes: @team_a_athletes,
              team_b_athletes: @team_b_athletes,
              team_a_participations_by_athlete: @team_a_participations_by_athlete,
              team_b_participations_by_athlete: @team_b_participations_by_athlete
            }),
            turbo_stream.replace("match-event-summary", partial: "matches/event_summary", locals: {
              match: @match,
              match_events: @match_events
            }),
            turbo_stream.replace("match-event-sheet-team-a", partial: "matches/event_sheet_table", locals: {
              id: "match-event-sheet-team-a",
              title: "Equipe A",
              team: @match.team_a,
              athletes: @team_a_athletes,
              match_events: @match_events
            }),
            turbo_stream.replace("match-event-sheet-team-b", partial: "matches/event_sheet_table", locals: {
              id: "match-event-sheet-team-b",
              title: "Equipe B",
              team: @match.team_b,
              athletes: @team_b_athletes,
              match_events: @match_events
            })
          ]
        end
        format.html { redirect_to edit_match_path(@match) }
      end
    end

    redirect_to match_path(@match), notice: "Jogo atualizado."
  rescue ActiveRecord::RecordInvalid
    load_match_context
    return head :unprocessable_entity if autosave_request?

    render :edit, status: :unprocessable_entity
  end

  private

  def scoped_matches
    return Match.includes(:championship, :category, :team_a, :team_b, :winner) if current_user&.admin?
    return Match.where(championship_id: current_championship.id) if current_championship.present?

    Match.none
  end

  def load_match_context
    @match = scoped_matches.includes(:championship, :category, :team_a, :team_b, :winner).find(params[:id])
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

  def match_params
    params.fetch(:match, {}).permit(
      :championship_id,
      :category_id,
      :team_a_id,
      :team_b_id,
      :venue_id,
      :venue,
      :code,
      :phase,
      :group_key,
      :round_number,
      :scheduled_on,
      :scheduled_time,
      :score_a,
      :score_b,
      :status,
      :decision,
      :wo,
      :winner_id,
      :penalties_a,
      :penalties_b
    )
  end

  def match_report_form_params
    params.fetch(:match_report, {}).permit(:referee_id)
  end

  def match_form_params
    params.fetch(:match, {}).permit(event_sheet: {})
  end

  def build_summula_import_preview
    uploaded_file = params.dig(:match_summula_import, :pdf)

    if uploaded_file.blank?
      redirect_to match_path(@match), alert: "Envie um PDF da súmula."
      return
    end

    preview = BolaCinco::MatchSummulaImport.new(match: @match, file: uploaded_file).call
    token = SecureRandom.hex(12)
    write_summula_import_preview(token, preview)
    write_summula_import_file(token, uploaded_file)

    @import_preview = preview.with_indifferent_access
    @import_token = token
    @import_athletes = import_athletes
    @import_team_options = import_team_options
    @available_venues = @match.championship.venues.order(:name)
    @import_preview_file_data_url = import_preview_file_data_url(token, preview[:file_content_type])
    render :import_summula
  end

  def confirm_summula_import
    token = params.dig(:match_summula_import, :token).to_s
    preview = read_summula_import_preview(token)

    if preview.blank?
      redirect_to match_path(@match), alert: "A prévia da súmula expirou. Envie o PDF novamente."
      return
    end

    payload = params.fetch(:match_summula_import, {}).to_unsafe_h.deep_symbolize_keys

    apply_summula_import(preview, payload)
    delete_summula_import_preview(token)

    redirect_to match_path(@match), notice: "Súmula importada e conferida."
  end

  def apply_summula_import(preview, payload)
    left_team = @match.championship.teams.find_by(id: payload[:left_team_id]).presence || @match.team_a
    right_team = @match.championship.teams.find_by(id: payload[:right_team_id]).presence || @match.team_b
    rows = payload.fetch(:rows, {}).values

    ActiveRecord::Base.transaction do
      match_attrs = {
        team_a: left_team,
        team_b: right_team,
        venue: venue_from_preview(preview)
      }
      match_attrs[:score_a] = payload[:score_a] if payload[:score_a].present?
      match_attrs[:score_b] = payload[:score_b] if payload[:score_b].present?
      match_attrs[:scheduled_on] = payload[:scheduled_on] if payload[:scheduled_on].present?
      match_attrs[:scheduled_time] = payload[:scheduled_time] if payload[:scheduled_time].present?

      @match.update!(match_attrs)
      @match.sync_pending_participations!

    rows.each do |row|
        team = row[:side].to_s == "right" ? right_team : left_team
        athlete = import_athlete_for_row(team, row)
        next if team.blank? || athlete.blank?

        participation = @match.match_participations.find_or_initialize_by(team: team, athlete: athlete)
        participation.source_id ||= "match-summula-import-#{@match.id}-#{team.id}-#{athlete.id}"
        participation.status = :confirmado
        participation.athlete_name = athlete.name
        participation.shirt_number = athlete.shirt_number
        participation.position = athlete.position
        participation.save!
      end
    end
  end

  def import_athlete_for_row(team, row)
    athlete_id = row[:athlete_id].presence
    if athlete_id.present?
      athlete = team.athletes.find_by(id: athlete_id) || Athlete.find_by(id: athlete_id)
      return athlete if athlete.present?
    end

    name = row[:player_name].to_s.strip
    return if team.blank? || name.blank?

    shirt_number = row[:shirt_number].to_s.strip.presence
    team_athletes = team.athletes.to_a
    athlete = team_athletes.find do |candidate|
      normalize_import_text(candidate.name) == normalize_import_text(name) ||
        (shirt_number.present? && candidate.shirt_number.to_s.strip == shirt_number)
    end
    return athlete if athlete.present?

    Athlete.create!(
      team: team,
      source_id: import_athlete_source_id(team, row),
      category: team.category || @match.category,
      name: name,
      shirt_number: shirt_number,
      status: :pendente
    )
  end

  def import_athlete_source_id(team, row)
    digest = Digest::SHA1.hexdigest(
      [
        @match.id,
        team.id,
        row[:side],
        row[:shirt_number],
        row[:player_name],
        row[:source_line]
      ].map(&:to_s).join("|")
    )[0, 24]

    "match-summula-import-athlete-#{digest}"
  end

  def normalize_import_text(value)
    I18n.transliterate(value.to_s).downcase.gsub(/[^a-z0-9]+/, " ").squish
  end

  def venue_from_preview(preview)
    return if preview.dig(:header, :venue).blank?

    @match.championship.venues.find_by(name: preview.dig(:header, :venue))
  end

  def import_athletes
    @match.championship.teams.includes(:athletes).order(:name).flat_map do |team|
      team.athletes.order(:shirt_number, :name).to_a
    end.uniq(&:id)
  end

  def import_team_options
    @match.championship.teams.order(:name)
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def championship_for_write
    championship_id = match_params[:championship_id].presence
    return Championship.find_by(id: championship_id) if championship_id.present?

    current_championship
  end

  def browser_form_submission?
    request.format.html? && request.referer.present?
  end

  def import_summula_preview_path(token)
    Rails.root.join("tmp", "match_summula_imports", "#{token}.json")
  end

  def import_summula_preview_file_path(token, original_filename)
    ext = File.extname(original_filename.to_s).presence || ".bin"
    Rails.root.join("tmp", "match_summula_imports", "#{token}#{ext}")
  end

  def write_summula_import_preview(token, preview)
    path = import_summula_preview_path(token)
    FileUtils.mkdir_p(path.dirname)
    File.write(path, JSON.pretty_generate(preview))
  end

  def write_summula_import_file(token, uploaded_file)
    path = import_summula_preview_file_path(token, uploaded_file.original_filename)
    FileUtils.mkdir_p(path.dirname)
    File.binwrite(path, File.binread(uploaded_file.path))
  end

  def read_summula_import_preview(token)
    path = import_summula_preview_path(token)
    return if token.blank? || !File.exist?(path)

    JSON.parse(File.read(path)).deep_symbolize_keys
  end

  def import_preview_file_data_url(token, content_type)
    return if content_type.to_s.blank? || !content_type.to_s.start_with?("image/")

    path = import_summula_preview_file_path(token, @import_preview[:file_name])
    return if token.blank? || !File.exist?(path)

    "data:#{content_type.presence || "application/octet-stream"};base64,#{Base64.strict_encode64(File.binread(path))}"
  end

  def delete_summula_import_preview(token)
    path = import_summula_preview_path(token)
    File.delete(path) if File.exist?(path)
  end

  def sync_tranca_partida_from_match(record)
    tranca_dupla_a = Tranca::Dupla.find_by(source_id: record.team_a&.source_id)
    tranca_dupla_b = Tranca::Dupla.find_by(source_id: record.team_b&.source_id)
    tranca_winner = Tranca::Dupla.find_by(source_id: record.winner&.source_id)
    tranca_rodada = Tranca::Rodada.find_or_initialize_by(
      championship_id: record.championship_id,
      phase: record.phase,
      round_number: record.round_number.to_i
    )
    tranca_rodada.assign_attributes(
      championship: record.championship,
      source_id: "tranca-round-#{record.championship.source_id}-#{record.phase}-#{record.round_number}",
      label: tranca_round_label(record.phase, record.round_number),
      status: tranca_round_status_for(record.status),
      starts_on: record.scheduled_on,
      ends_on: record.scheduled_on
    )
    tranca_rodada.save!

    tranca_mesa = Tranca::Mesa.find_or_initialize_by(
      championship_id: record.championship_id,
      code: record.code
    )
    tranca_mesa.assign_attributes(
      championship: record.championship,
      tranca_rodada: tranca_rodada,
      source_id: "tranca-mesa-#{record.source_id}",
      name: record.venue_name.presence || "Mesa #{record.code}",
      location: record.venue_name,
      status: tranca_mesa_status_for(record.status)
    )
    tranca_mesa.save!

    tranca_partida = Tranca::Partida.find_or_initialize_by(source_id: record.source_id)
    tranca_partida.assign_attributes(
      championship: record.championship,
      category: record.category,
      tranca_rodada: tranca_rodada,
      tranca_mesa: tranca_mesa,
      dupla_a: tranca_dupla_a,
      dupla_b: tranca_dupla_b,
      winner: tranca_winner,
      code: record.code,
      phase: record.phase,
      round_number: record.round_number,
      group_key: record.group_key,
      scheduled_on: record.scheduled_on,
      scheduled_time: record.scheduled_time,
      status: record.status,
      score_a: record.score_a,
      score_b: record.score_b,
      decision: record.decision,
      penalties_a: record.penalties_a,
      penalties_b: record.penalties_b,
      wo: record.wo,
      source_data: record.source_data
    )
    tranca_partida.save!
  end

  def tranca_round_label(phase, round_number)
    phase_label = case phase.to_s
    when "classificatoria" then "Classificatória"
    when "mata_mata" then "Mata-mata"
    else phase.to_s.tr("_", " ").humanize
    end

    round_number.to_i.positive? ? "Rodada #{round_number} · #{phase_label}" : phase_label
  end

  def tranca_round_status_for(status)
    case status.to_s
    when "finalizado", "wo" then "encerrada"
    when "em_andamento" then "em_andamento"
    else "programada"
    end
  end

  def tranca_mesa_status_for(status)
    case status.to_s
    when "finalizado", "wo" then "ocupada"
    when "em_andamento" then "em_uso"
    else "disponivel"
    end
  end
end
