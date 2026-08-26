class MatchReportsController < ApplicationController
  def index
    @match_reports = scoped_match_reports.order(created_at: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @match_reports }
    end
  end

  def show
    @match_report = match_report
    respond_to do |format|
      format.html
      format.json { render json: match_report }
    end
  end

  def create
    record = match.match_report || match.build_match_report(match_report_params)
    record.source_id = default_source_id("report") if record.source_id.blank?

    if html_form_submission?
      record.assign_attributes(match_report_params)
      record.status = :rascunho
      record.submitted_at = Time.current
      record.approved_at = nil

      if record.save
        redirect_to match_path(match), notice: "Relatório salvo."
      else
        @match_report = record
        @match = match
        @available_referees = @match.championship.referees.order(:name)
        @available_athletes = @match.roster_athletes
        @available_teams = [@match.team_a, @match.team_b].compact.uniq
        render "matches/show", status: :unprocessable_entity
      end
    elsif record.new_record? ? record.save : record.update(match_report_params)
      render json: record, status: record.previous_changes.key?("id") ? :created : :ok
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if html_form_submission?
      match_report.assign_attributes(match_report_params)
      match_report.status = :rascunho
      match_report.submitted_at = Time.current
      match_report.approved_at = nil

      if match_report.save
        redirect_to match_report_path(match_report), notice: "Relatório atualizado."
      else
        @match_report = match_report
        render :show, status: :unprocessable_entity
      end
    elsif match_report.update(match_report_params)
      render json: match_report
    else
      render json: { errors: match_report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def approve
    match_report.update!(
      status: :aprovado,
      approved_at: Time.current,
      submitted_at: match_report.submitted_at || Time.current
    )

    redirect_to match_reports_path, notice: "Relatório aprovado."
  end

  def destroy
    match_report.destroy!

    return redirect_to match_path(match_report.match), notice: "Relatório removido." if html_form_submission?

    head :no_content
  end

  private

  def scoped_match_reports
    scope = MatchReport.includes(:match, :referee)
    scope = scope.joins(:match).where(matches: { championship_id: params[:championship_id] }) if params[:championship_id].present?
    scope
  end

  def match
    @match ||= Match.find(params[:match_id])
  end

  def match_report
    @match_report ||= MatchReport.find(params[:id])
  end

  def match_report_params
    params.expect(match_report: [
      :source_id,
      :referee_id,
      :status,
      :submitted_at,
      :approved_at,
      :notes,
      :sheet_url,
      { source_data: {} }
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
