class VenuesController < ApplicationController
  def index
    @venues = scoped_venues.order(:name)
    @venue = scoped_championship.venues.new(status: :ativo)
    respond_to do |format|
      format.html
      format.json { render json: @venues }
    end
  end

  def show
    @venue = venue
    respond_to do |format|
      format.html
      format.json { render json: venue }
    end
  end

  def create
    record = scoped_championship.venues.new(venue_params)
    record.source_id = default_source_id("venue") if record.source_id.blank?

    if html_form_submission?
      if record.save
        redirect_to venue_path(record), notice: "Local criado."
      else
        @venues = scoped_venues.order(:name)
        @venue = record
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
      if venue.update(venue_params)
        redirect_to venue_path(venue), notice: "Local atualizado."
      else
        @venue = venue
        render :show, status: :unprocessable_entity
      end
    elsif venue.update(venue_params)
      render json: venue
    else
      render json: { errors: venue.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def attach
    venue.update!(championship: scoped_championship)
    redirect_back fallback_location: setup_championship_path(scoped_championship, step: "teams"), notice: "Local vinculado ao campeonato."
  end

  def detach
    venue.update!(championship: nil)
    redirect_back fallback_location: setup_championship_path(scoped_championship, step: "teams"), notice: "Local desvinculado do campeonato."
  end

  def destroy
    venue.destroy!

    return redirect_to venues_path, notice: "Local removido." if html_form_submission?

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

  def scoped_venues
    @scoped_venues ||= scoped_championship.venues.includes(:championship)
  end

  def venue
    @venue ||= Venue.find(params[:id])
  end

  def venue_params
    params.expect(venue: [
      :source_id,
      :name,
      :short_name,
      :city,
      :address,
      :notes,
      :status,
      :championship_id
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
