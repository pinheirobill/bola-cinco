require "test_helper"

class PublicTeamSignupTest < ActionDispatch::IntegrationTest
  setup do
    @championship = Championship.create!(
      source_id: "champ-public-team-signup",
      name: "Campeonato Inscrição Time",
      season: 2026,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-public-team-signup",
      championship: @championship,
      name: "Sub 16"
    )

    other_championship = Championship.create!(
      source_id: "champ-public-team-signup-other",
      name: "Campeonato Base",
      season: 2025,
      status: :em_andamento
    )

    @existing_category = Category.create!(
      source_id: "cat-public-team-signup-other",
      championship: other_championship,
      name: "Sub 14"
    )

    @entity = Entity.create!(
      source_id: "entity-public-team-signup",
      name: "Escola Pública"
    )

    @team = Team.create!(
      source_id: "team-public-team-signup",
      entity: @entity,
      category: @existing_category,
      name: "Time Público",
      short_name: "Público"
    )

    @tranca_championship = Championship.create!(
      source_id: "champ-public-team-signup-tranca",
      name: "Campeonato Tranca Público",
      season: 2026,
      status: :em_andamento,
      modality: :tranca,
      start_date: Date.new(2026, 9, 20),
      end_date: Date.new(2026, 11, 15),
      registration_start: Date.new(2026, 9, 1),
      registration_end: Date.new(2026, 9, 18),
      notes: "Inscrição exclusiva para duplas da Tranca.\nLançamento sujeito à conferência da organização."
    )

    @tranca_category = @tranca_championship.ensure_tranca_onboarding_category!

    @tranca_entity = Entity.create!(
      source_id: "entity-public-team-signup-tranca",
      name: "Dupla Pública"
    )

    @tranca_team = Team.create!(
      source_id: "team-public-team-signup-tranca",
      entity: @tranca_entity,
      category: @tranca_category,
      name: "Dupla Pública"
    )

    @tranca_recent_team_two = Team.create!(
      source_id: "team-public-team-signup-tranca-2",
      entity: Entity.create!(
        source_id: "entity-public-team-signup-tranca-2",
        name: "Dupla Recente 2"
      ),
      category: @tranca_category,
      name: "Dupla Recente 2"
    )

    @tranca_recent_team_three = Team.create!(
      source_id: "team-public-team-signup-tranca-3",
      entity: Entity.create!(
        source_id: "entity-public-team-signup-tranca-3",
        name: "Dupla Recente 3"
      ),
      category: @tranca_category,
      name: "Dupla Recente 3"
    )
  end

  test "selects an existing team without creating new records" do
    assert_no_difference -> { Entity.count } do
      assert_no_difference -> { Team.count } do
        post championship_team_signup_path(@championship), params: {
          team_signup: {
            signup_mode: "existing",
            team_id: @team.id,
            category_id: @category.id
          }
        }
      end
    end

    assert_response :redirect
    assert_equal @category, @team.reload.category
  end

  test "creates a new team when the public form is set to new team signup" do
    assert_difference -> { Entity.count }, 1 do
      assert_difference -> { Team.count }, 1 do
        post championship_team_signup_path(@championship), params: {
          team_signup: {
            signup_mode: "new",
            category_id: @category.id,
            entity_name: "Nova Escola",
            team_name: "Equipe Nova",
            short_name: "Nova"
          }
        }
      end
    end

    assert_response :redirect
    team = Team.order(:created_at).last
    assert_equal "Equipe Nova", team.name
    assert_equal "Nova Escola", team.entity.name
    assert_equal @category, team.category
    assert team.registration_status_pendente?
  end

  test "increments the public signup visit count when opening the link" do
    assert_difference -> { @championship.reload.public_signup_visits_total }, 1 do
      post championship_team_signup_path(@championship), params: {
        visit_only: "1"
      }
    end

    assert_response :no_content
  end

  test "shows validation errors when the team is missing" do
    post championship_team_signup_path(@championship), params: {
      team_signup: {
        category_id: @category.id
      }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "time"
  end

  test "shows the tranca signup page with duo labels" do
    get new_championship_team_signup_path(@tranca_championship)

    assert_response :success
    assert_includes response.body, "Inscrição de duplas"
    assert_includes response.body, "Selecionar dupla cadastrada"
    assert_includes response.body, "Cadastrar nova dupla"
    assert_includes response.body, "Dupla Pública"
    assert_includes response.body, "Calendário"
    assert_includes response.body, "01/09/2026"
    assert_includes response.body, "18/09/2026"
    assert_includes response.body, "20/09/2026"
    assert_includes response.body, "15/11/2026"
    assert_includes response.body, "Inscrição exclusiva para duplas da Tranca"
  end

  test "selects an existing tranca duo without creating new records" do
    assert_no_difference -> { Entity.count } do
      assert_no_difference -> { Team.count } do
        post championship_team_signup_path(@tranca_championship), params: {
          team_signup: {
            signup_mode: "existing",
            team_id: @tranca_team.id,
            category_id: @tranca_category.id
          }
        }
      end
    end

    assert_response :redirect
    assert_redirected_to championship_path(@tranca_championship, anchor: "duplas", signup_team: @tranca_team.source_id)
    assert_equal @tranca_category, @tranca_team.reload.category
    assert @tranca_team.registration_status_pendente?
  end

  test "creates a new tranca duo and auto-creates the entity from the duo name" do
    assert_difference -> { Entity.count }, 1 do
      assert_difference -> { Team.count }, 1 do
        post championship_team_signup_path(@tranca_championship), params: {
          team_signup: {
            signup_mode: "new",
            category_id: @tranca_category.id,
            team_name: "Joao / Maria",
            short_name: "J / M"
          }
        }
      end
    end

    assert_response :redirect
    team = Team.order(:created_at).last
    assert_redirected_to championship_path(@tranca_championship, anchor: "duplas", signup_team: team.source_id)
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Sua dupla foi cadastrada"
    assert_includes response.body, "Últimas duplas cadastradas"
    assert_includes response.body, "Joao / Maria"
    assert_includes response.body, "Dupla Recente 2"
    assert_includes response.body, "Dupla Recente 3"
    assert_includes response.body, "Cadastrada"
    assert_equal "Joao / Maria", team.name
    assert_equal "Joao / Maria", team.entity.name
    assert_equal "J / M", team.short_name
    assert_equal @tranca_category, team.category
    assert team.registration_status_pendente?
  end
end
