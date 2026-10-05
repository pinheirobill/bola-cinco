require "image_processing/mini_magick"

class ChampionshipPhotosController < ApplicationController
  MAX_UPLOAD_SIZE = 20.megabytes
  MAX_STORED_SIZE = 5.megabytes
  MAX_DIMENSION = 1920

  skip_before_action :authenticate_user!, only: :index

  def index
    @championship = championship_lookup
    return forbidden! unless @championship.visible_by?(current_user) || @championship.publicly_visible? || current_user&.admin?

    @photos = @championship.photos.order(created_at: :desc)
  end

  def create
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    uploads = Array(photo_params[:photos]).compact_blank
    return redirect_to championship_photos_path(@championship), alert: "Selecione pelo menos uma foto." if uploads.empty?

    raise ArgumentError, "Envie até 10 fotos por vez." if uploads.size > 10

    processed = []
    uploads.each { |upload| processed << process_photo(upload) }
    processed.each do |file|
      file.open do |io|
        @championship.photos.attach(io:, filename: file.basename, content_type: "image/jpeg")
      end
    end

    redirect_to championship_photos_path(@championship), notice: "#{processed.size} foto(s) adicionada(s)."
  rescue ArgumentError, ImageProcessing::Error => e
    redirect_to championship_photos_path(@championship), alert: e.message
  ensure
    processed&.each(&:close!)
  end

  def destroy
    @championship = championship_lookup
    return forbidden! unless @championship.manageable_by?(current_user)

    @championship.photos.find(params[:id]).purge
    redirect_to championship_photos_path(@championship), notice: "Foto removida."
  end

  private

  def photo_params
    params.require(:championship_photo).permit(photos: [])
  end

  def process_photo(upload)
    raise ArgumentError, "Cada foto deve ter no máximo 20 MB." if upload.size > MAX_UPLOAD_SIZE
    unless upload.content_type.in?(%w[image/jpeg image/png image/webp])
      raise ArgumentError, "Envie fotos nos formatos JPG, PNG ou WebP."
    end

    ImageProcessing::MiniMagick.source(upload.tempfile)
      .resize_to_limit(MAX_DIMENSION, MAX_DIMENSION)
      .convert("jpg")
      .saver(quality: 78, strip: true)
      .call.tap do |file|
        if file.size > MAX_STORED_SIZE
          file.close!
          raise ArgumentError, "Uma foto ficou maior que 5 MB mesmo depois da redução."
        end
      end
  end

  def championship_lookup
    identifier = params[:championship_id].to_s
    legacy_id = identifier[/\A(\d+)-/, 1]
    Championship.find_by(slug: identifier) || Championship.find_by(id: identifier) ||
      Championship.find_by(id: legacy_id) || Championship.find(identifier)
  end
end
