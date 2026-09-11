require "tempfile"

module BolaCinco
  module ChampionshipLogoPdf
    private

    def with_championship_logo(championship)
      attachment = championship&.logo&.attachment
      blob = attachment&.blob
      return unless blob.present?
      return unless blob.content_type.to_s.start_with?("image/")

      file = Tempfile.new(["championship-logo", File.extname(blob.filename.to_s).presence || ".png"], binmode: true)
      file.write(blob.download)
      file.rewind
      yield file.path
    ensure
      file&.close!
      file&.unlink if file && !file.closed?
    end
  end
end
