require "test_helper"

class PhaseFivePlatformTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @editor = users(:two)
    sign_in @admin

    @championship_1 = Championship.create!(
      source_id: "champ-platform-1",
      name: "Campeonato Plataforma 1",
      season: 2025
    )

    @championship_2 = Championship.create!(
      source_id: "champ-platform-2",
      name: "Campeonato Plataforma 2",
      season: 2026
    )

    ChampionshipMembership.create!(
      source_id: "cm-1",
      championship: @championship_2,
      user: @editor,
      role: :editor
    )
  end

  test "selects active championship by endpoint" do
    post active_championship_path, params: { championship_id: @championship_2.id }

    assert_response :success
    assert_equal @championship_2.id, JSON.parse(response.body).fetch("id")

    get active_championship_path

    assert_response :success
    assert_equal @championship_2.id, JSON.parse(response.body).fetch("id")
  end

  test "shows the championship setup flow on a dedicated page" do
    get setup_championship_path(@championship_2)

    assert_response :success
    assert_includes response.body, "Configuração do campeonato"
    assert_includes response.body, "Etapa 1. Dados"
    refute_includes response.body, "Portal aberto"
  end

  test "shows venues and referees on the teams setup step" do
    @championship_2.venues.create!(
      source_id: "venue-phase-five",
      name: "INTERLAGOS"
    )

    @championship_2.referees.create!(
      source_id: "ref-phase-five",
      name: "ROSIVALDO DE SOUSA"
    )

    get setup_championship_path(@championship_2, step: "teams")

    assert_response :success
    assert_includes response.body, "Campos"
    assert_includes response.body, "Árbitros"
    assert_includes response.body, "INTERLAGOS"
    assert_includes response.body, "ROSIVALDO DE SOUSA"
    assert_includes response.body, "Gerenciar"
    assert_includes response.body, "Remover"
  end

  test "can attach and detach a venue from the championship" do
    venue = Venue.create!(
      source_id: "venue-phase-five-detach",
      name: "CAMPO LIVRE"
    )

    patch attach_venue_path(venue), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_equal @championship_2, venue.reload.championship

    patch detach_venue_path(venue), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_nil venue.reload.championship
  end

  test "can attach and detach a referee from the championship" do
    referee = Referee.create!(
      source_id: "ref-phase-five-detach",
      name: "ÁRBITRO LIVRE"
    )

    patch attach_referee_path(referee), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_equal @championship_2, referee.reload.championship

    patch detach_referee_path(referee), params: { championship_id: @championship_2.id }
    assert_response :redirect
    assert_nil referee.reload.championship
  end

  test "forbids selecting championship without access" do
    sign_in @editor

    post active_championship_path, params: { championship_id: @championship_1.id }

    assert_response :forbidden
  end

  test "admin can create championship membership" do
    post championship_championship_memberships_path(@championship_1), params: {
      championship_membership: {
        source_id: "cm-2",
        user_id: @editor.id,
        role: "leitor"
      }
    }

    assert_response :created
    assert_equal "leitor", JSON.parse(response.body).fetch("role")
  end

  test "dashboard exposes accessible championships for regular users" do
    sign_in @editor

    get root_path

    assert_response :success
  end
end
