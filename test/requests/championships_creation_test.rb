require "test_helper"

class ChampionshipsCreationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @editor = users(:two)
  end

  test "admin can open the new championship form" do
    sign_in @admin

    get new_championship_path

    assert_response :success
    assert_includes response.body, "Novo campeonato"
    assert_includes response.body, "Criar e iniciar onboarding"
    assert_includes response.body, "Modalidade"
  end

  test "admin can create a championship and reach setup" do
    sign_in @admin

    assert_difference -> { Championship.count }, 1 do
      post championships_path, params: {
        championship: {
          name: "Campeonato Novo",
          season: 2026,
          modality: "football"
        }
      }
    end

    championship = Championship.order(created_at: :desc).first

    assert_redirected_to setup_championship_path(championship, step: "data")
    assert_equal "rascunho", championship.status
    assert_equal "football", championship.modality
    assert_not_nil championship.source_id
    assert_not_nil championship.slug
  end

  test "admin can create a tranca championship" do
    sign_in @admin

    assert_difference -> { Championship.where(modality: "tranca").count }, 1 do
      post championships_path, params: {
        championship: {
          name: "Campeonato Tranca",
          season: 2026,
          modality: "tranca"
        }
      }
    end

    championship = Championship.order(created_at: :desc).first

    assert_equal "tranca", championship.modality
  end

  test "admin can upload a championship logo from setup" do
    sign_in @admin

    championship = Championship.create!(
      source_id: "championship-logo-upload",
      name: "Campeonato com Logo",
      season: 2026
    )

    patch championship_path(championship), params: {
      current_step: "data",
      championship: {
        logo: fixture_file_upload("championship-logo.png", "image/png")
      }
    }

    assert_redirected_to setup_championship_path(championship, step: "data")
    assert championship.reload.logo.attached?
  end

  test "admin can reach setup through a legacy prefixed championship identifier" do
    sign_in @admin
    championship = Championship.create!(
      source_id: "championship-legacy-identifier",
      name: "Campeonato Legado",
      season: 2026
    )
    championship.update_column(:slug, nil)

    get setup_championship_path("#{championship.id}-campeonato-legado-2026", step: "data")

    assert_response :success
    assert_includes response.body, "Configuração do campeonato"
  end

  test "non-admin cannot open or create championships" do
    sign_in @editor

    get new_championship_path
    assert_response :forbidden

    post championships_path, params: {
      championship: {
        name: "Campeonato Bloqueado",
        season: 2026
      }
    }
    assert_response :forbidden
  end
end
