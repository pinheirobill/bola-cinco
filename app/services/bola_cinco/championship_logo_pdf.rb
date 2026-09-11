require "tempfile"

module BolaCinco
  module ChampionshipLogoPdf
    private

    def with_championship_logo(championship)
      return unless championship&.logo&.attached?
      return unless championship.logo.blob.content_type.to_s.start_with?("image/")

      file = Tempfile.new(["championship-logo", File.extname(championship.logo.filename.to_s).presence || ".png"], binmode: true)
      file.write(championship.logo.download)
      file.rewind
      yield file.path
    ensure
      file&.close!
      file&.unlink if file && !file.closed?
    end
  end
end
