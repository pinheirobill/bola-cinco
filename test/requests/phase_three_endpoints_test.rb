require "test_helper"

class PhaseThreeEndpointsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @championship = Championship.create!(
      source_id: "champ-phase-three",
      name: "Campeonato Fase 3",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-phase-three",
      championship: @championship,
      name: "Sub 17"
    )

    @entity = Entity.create!(
      source_id: "entity-phase-three",
      name: "Escola Fase 3"
    )
  end

  test "creates a team in pending registration" do
    post teams_path, params: {
      team: {
        source_id: "team-phase-three",
        entity_id: @entity.id,
        category_id: @category.id,
        name: "Time Fase 3"
      }
    }

    assert_response :created
    team = Team.find_by(source_id: "team-phase-three")
    assert team.registration_status_pendente?
  end

  test "approves a team by update" do
    team = Team.create!(
      source_id: "team-phase-three-2",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 B"
    )

    patch team_path(team), params: {
      team: {
        registration_status: "aprovada"
      }
    }

    assert_redirected_to team_path(team)
    assert team.reload.registration_status_aprovada?
  end

  test "admin confirms a pending team registration" do
    team = Team.create!(
      source_id: "team-phase-three-2b",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 BB"
    )

    patch confirm_registration_team_path(team)

    assert_redirected_to team_path(team)
    assert team.reload.registration_status_aprovada?
  end

  test "admin rejects a pending team registration" do
    team = Team.create!(
      source_id: "team-phase-three-2c",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 CC"
    )

    patch reject_registration_team_path(team)

    assert_redirected_to team_path(team)
    assert team.reload.registration_status_rejeitada?
  end

  test "admin can change a team registration status after it was approved" do
    team = Team.create!(
      source_id: "team-phase-three-2d",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 DD"
    )

    team.approve!

    patch team_path(team), params: {
      team: {
        registration_status: "rejeitada"
      }
    }

    assert_redirected_to team_path(team)
    assert team.reload.registration_status_rejeitada?
  end

  test "creates an athlete linked to a user" do
    athlete_user = User.create!(
      email: "atleta.fase3@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :jogador_do_time
    )

    team = Team.create!(
      source_id: "team-phase-three-3",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 C"
    )

    post athletes_path, params: {
      athlete: {
        source_id: "athlete-phase-three",
        team_id: team.id,
        category_id: @category.id,
        user_id: athlete_user.id,
        name: "Atleta Fase 3"
      }
    }

    assert_response :created
    athlete = Athlete.find_by(source_id: "athlete-phase-three")
    assert_equal athlete_user, athlete.user
  end

  test "links the current user to a team" do
    team = Team.create!(
      source_id: "team-phase-three-4",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 D"
    )

    post team_team_memberships_path(team), params: {
      team_membership: {
        source_id: "membership-phase-three",
        role: "capitao"
      }
    }

    assert_response :created
    membership = TeamMembership.find_by(source_id: "membership-phase-three")
    assert_equal @user, membership.user
    assert membership.role_capitao?
  end

  test "links and unlinks an athlete from a team" do
    team_a = Team.create!(
      source_id: "team-phase-three-5",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 E"
    )

    team_b = Team.create!(
      source_id: "team-phase-three-6",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 F"
    )

    athlete = Athlete.create!(
      source_id: "athlete-phase-three-2",
      team: team_a,
      category: @category,
      name: "Atleta Fase 3 B"
    )
    athlete.validate_registration!

    post team_team_athletes_path(team_b), params: {
      team_athlete: {
        athlete_id: athlete.id
      }
    }

    assert_redirected_to team_path(team_b)
    assert_includes team_b.reload.athletes, athlete

    link = team_b.team_athletes.find_by!(athlete: athlete)

    delete team_team_athlete_path(team_b, link)

    assert_redirected_to team_path(team_b)
    refute_includes team_b.reload.athletes, athlete
  end

  test "links multiple athletes at once to a team" do
    primary_team = Team.create!(
      source_id: "team-phase-three-5-primary",
      entity: @entity,
      category: @category,
      name: "Time Base Fase 3 Multi"
    )

    team = Team.create!(
      source_id: "team-phase-three-5-multi",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 Multi"
    )

    athlete_one = Athlete.create!(
      source_id: "athlete-phase-three-multi-1",
      team: primary_team,
      category: @category,
      name: "Atleta Multi 1"
    )

    athlete_two = Athlete.create!(
      source_id: "athlete-phase-three-multi-2",
      team: primary_team,
      category: @category,
      name: "Atleta Multi 2"
    )

    athlete_one.validate_registration!
    athlete_two.validate_registration!

    post team_team_athletes_path(team), params: {
      team_athlete: {
        athlete_ids: [athlete_one.id, athlete_two.id]
      }
    }

    assert_redirected_to team_path(team)
    assert_includes team.reload.athletes, athlete_one
    assert_includes team.reload.athletes, athlete_two
  end

  test "lists active athletes from any championship when linking a team" do
    other_championship = Championship.create!(
      source_id: "champ-phase-three-extra",
      name: "Campeonato Fase 3 Extra",
      season: 2026
    )

    other_category = Category.create!(
      source_id: "cat-phase-three-extra-2",
      championship: other_championship,
      name: "Sub 18"
    )

    primary_team = Team.create!(
      source_id: "team-phase-three-10-primary",
      entity: @entity,
      category: other_category,
      name: "Time Base Fase 3"
    )

    team = Team.create!(
      source_id: "team-phase-three-10",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 J"
    )

    linked_athlete = Athlete.create!(
      source_id: "athlete-phase-three-5",
      team: primary_team,
      category: other_category,
      name: "Atleta Fase 3 E"
    )

    available_athlete = Athlete.create!(
      source_id: "athlete-phase-three-6",
      team: primary_team,
      category: other_category,
      name: "Atleta Fase 3 F"
    )

    pending_athlete = Athlete.create!(
      source_id: "athlete-phase-three-7",
      team: primary_team,
      category: other_category,
      name: "Atleta Fase 3 G",
      status: :pendente
    )

    linked_athlete.validate_registration!
    available_athlete.validate_registration!

    TeamAthlete.create!(
      source_id: "team-athlete-phase-three-linked",
      team: team,
      athlete: linked_athlete
    )

    get team_path(team)

    assert_response :success
    assert_includes response.body, "Buscar atleta"
    assert_includes response.body, "Equipe atual"
    assert_includes response.body, "Apelido / nome curto"
    assert_includes response.body, "Camisa"
    assert_includes response.body, linked_athlete.name
    assert_includes response.body, "Já está na equipe"
    assert_includes response.body, available_athlete.name
    assert_includes response.body, pending_athlete.name

    post team_team_athletes_path(team), params: {
      team_athlete: {
        athlete_ids: [available_athlete.id]
      }
    }

    assert_redirected_to team_path(team)
    assert_includes team.reload.athletes, linked_athlete
    assert_includes team.reload.athletes, available_athlete
  end

  test "links and unlinks a team from the athlete page" do
    team_a = Team.create!(
      source_id: "team-phase-three-7",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 G"
    )

    team_b = Team.create!(
      source_id: "team-phase-three-8",
      entity: @entity,
      category: @category,
      name: "Time Fase 3 H"
    )

    athlete = Athlete.create!(
      source_id: "athlete-phase-three-3",
      team: team_a,
      category: @category,
      name: "Atleta Fase 3 C"
    )

    post athlete_team_links_path(athlete), params: {
      team_link: {
        team_id: team_b.id
      }
    }

    assert_redirected_to athlete_path(athlete)
    assert_includes athlete.reload.linked_teams, team_b

    link = athlete.team_athletes.find_by!(team: team_b)

    delete athlete_team_link_path(athlete, link)

    assert_redirected_to athlete_path(athlete)
    refute_includes athlete.reload.linked_teams, team_b
  end
end
