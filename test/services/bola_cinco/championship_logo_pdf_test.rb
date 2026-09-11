require "test_helper"

class BolaCinco::ChampionshipLogoPdfTest < ActiveSupport::TestCase
  class Renderer
    include BolaCinco::ChampionshipLogoPdf

    def render_logo(championship, &block)
      with_championship_logo(championship, &block)
    end
  end

  test "skips missing championship logo files without raising" do
    blob = Object.new
    blob.define_singleton_method(:content_type) { "image/png" }
    blob.define_singleton_method(:filename) { "logo.png" }
    blob.define_singleton_method(:download) { raise ActiveStorage::FileNotFoundError, "missing file" }

    attachment = Struct.new(:blob).new(blob)
    logo = Struct.new(:attachment).new(attachment)
    championship = Struct.new(:logo).new(logo)

    called = false

    assert_nothing_raised do
      Renderer.new.render_logo(championship) do
        called = true
      end
    end

    assert_not called
  end
end
