class Tranca::DuplaImportsController < ApplicationController
  before_action :load_championship

  def new
  end

  def template
    send_file Rails.root.join("lib/templates/tranca_duplas.xlsx"), filename: "modelo-importacao-duplas.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", disposition: "attachment"
  end

  def preview
    @category = import_categories.find(params[:category_id])
    rows = Tranca::DuplasSpreadsheet.read(params[:file])
    @entries = importer(rows).preview
    @token = verifier.generate({ "user_id" => current_user.id, "championship_id" => @championship.id,
      "category_id" => @category.id, "rows" => rows }, expires_in: 30.minutes, purpose: "tranca-duplas-import")
    render :preview
  rescue Tranca::DuplasSpreadsheet::InvalidFile, Tranca::DuplasImport::InvalidImport => error
    flash.now[:alert] = error.message
    render :new, status: :unprocessable_entity
  end

  def create
    payload = verifier.verified(params[:token].to_s, purpose: "tranca-duplas-import")
    unless payload && payload["user_id"] == current_user.id && payload["championship_id"] == @championship.id
      return redirect_to new_championship_dupla_import_path(@championship), alert: "Prévia inválida ou expirada. Envie o Excel novamente."
    end

    @category = import_categories.find(payload.fetch("category_id"))
    @entries = importer(payload.fetch("rows")).call
    render :result
  rescue Tranca::DuplasImport::InvalidImport, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => error
    Rails.logger.warn("Tranca dupla import failed: #{error.class.name}")
    redirect_to new_championship_dupla_import_path(@championship),
      alert: "A importação foi cancelada sem gravar duplas. Revise os cadastros e envie novamente."
  end

  private

  def load_championship
    identifier = params[:championship_id].to_s
    @championship = Championship.find_by(slug: identifier) || Championship.find_by(id: identifier[/\A\d+/])
    raise ActiveRecord::RecordNotFound unless @championship
    return forbidden! unless @championship.tranca? && @championship.manageable_by?(current_user)

    set_current_championship(@championship)
    @categories = import_categories.order(:name)
  end

  def import_categories
    @championship.categories.where(championship_id: @championship.id)
      .where.not(id: ChampionshipCategory.where.not(championship_id: @championship.id).select(:category_id))
  end

  def importer(rows)
    Tranca::DuplasImport.new(championship: @championship, category: @category, rows: rows)
  end

  def verifier
    Rails.application.message_verifier("tranca-duplas-import")
  end
end
