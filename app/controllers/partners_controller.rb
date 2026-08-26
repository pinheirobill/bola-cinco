class PartnersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @partners = scoped_partners.order(highlight: :desc, created_at: :desc)
    @partner = scoped_championship.partners.new(status: :ativo, tier: :parceiro)
    @categories = scoped_championship.categories.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: @partners }
    end
  end

  def show
    @partner = partner
    @categories = scoped_championship.categories.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: partner }
    end
  end

  def create
    record = scoped_championship.partners.new(partner_params)
    record.source_id = default_source_id("partner") if record.source_id.blank?

    if html_form_submission?
      if record.save
        redirect_to partner_path(record), notice: "Parceiro criado."
      else
        @partners = scoped_partners.order(highlight: :desc, created_at: :desc)
        @partner = record
        @categories = scoped_championship.categories.order(:name)
        render :index, status: :unprocessable_entity
      end
    elsif record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if autosave_request?
      if partner.update(partner_params)
        head :no_content
      else
        head :unprocessable_entity
      end
    elsif html_form_submission?
      if partner.update(partner_params)
        redirect_to partner_path(partner), notice: "Parceiro atualizado."
      else
        @partner = partner
        @categories = scoped_championship.categories.order(:name)
        render :show, status: :unprocessable_entity
      end
    elsif partner.update(partner_params)
      render json: partner
    else
      render json: { errors: partner.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    partner.destroy!

    return redirect_to partners_path, notice: "Parceiro removido." if html_form_submission?

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

  def scoped_partners
    scope = scoped_championship.partners.includes(:championship, :category)
    scope = scope.status_ativo unless current_user&.admin?
    @scoped_partners ||= scope
  end

  def partner
    @partner ||= scoped_partners.find(params[:id])
  end

  def partner_params
    params.expect(partner: [
      :source_id,
      :category_id,
      :name,
      :tier,
      :status,
      :logo_url,
      :website_url,
      :highlight,
      :notes,
      { source_data: {} }
    ])
  end

  def default_source_id(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end
end
