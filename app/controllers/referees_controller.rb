class RefereesController < ApplicationController
  def index
    @referees = scoped_referees.order(:name)
    @referee = scoped_championship.referees.new(status: :ativo)
    respond_to do |format|
      format.html
      format.json { render json: @referees }
    end
  end

  def show
    @referee = referee
    respond_to do |format|
      format.html
      format.json { render json: referee }
    end
  end

  def create
    record = scoped_championship.referees.new(referee_params)
    record.source_id = default_source_id("referee") if record.source_id.blank?

    if html_form_submission?
      if record.save
        redirect_to referee_path(record), notice: "Árbitro criado."
      else
        @referees = scoped_referees.order(:name)
        @referee = record
        render :index, status: :unprocessable_entity
      end
    elsif record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if html_form_submission?
      if referee.update(referee_params)
        redirect_to referee_path(referee), notice: "Árbitro atualizado."
      else
        @referee = referee
        render :show, status: :unprocessable_entity
      end
    elsif referee.update(referee_params)
      render json: referee
    else
      render json: { errors: referee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def attach
    referee.update!(championship: scoped_championship)
    redirect_back fallback_location: setup_championship_path(scoped_championship, step: "teams"), notice: "Árbitro vinculado ao campeonato."
  end

  def detach
    referee.update!(championship: nil)
    redirect_back fallback_location: setup_championship_path(scoped_championship, step: "teams"), notice: "Árbitro desvinculado do campeonato."
  end

  def destroy
    referee.destroy!

    return redirect_to referees_path, notice: "Árbitro removido." if html_form_submission?

    head :no_content
  end

  private

  def scoped_championship
    @scoped_championship ||= if params[:championship_id].present?
      Championship.find_by(id: params[:championship_id]) || Championship.find_by(slug: params[:championship_id]) || raise(ActiveRecord::RecordNotFound)
    else
      current_championship || raise(ActiveRecord::RecordNotFound)
    end
  end

  def scoped_referees
    @scoped_referees ||= scoped_championship.referees.includes(:championship)
  end

  def referee
    @referee ||= Referee.find(params[:id])
  end

  def referee_params
    params.expect(referee: [
      :source_id,
      :name,
      :document,
      :phone,
      :email,
      :notes,
      :status,
      :championship_id
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
