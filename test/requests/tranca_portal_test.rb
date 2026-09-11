require "test_helper"

class TrancaPortalTest < ActionDispatch::IntegrationTest
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-portal",
      name: "CAMPEONATO DE TRANCA 2026",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-tranca-portal",
      championship: @championship,
      name: "Livre"
    )

    @entity_a = Entity.create!(
      source_id: "entity-tranca-a",
      name: "Dupla A"
    )

    @entity_b = Entity.create!(
      source_id: "entity-tranca-b",
      name: "Dupla B"
    )

    @team_a = Team.create!(
      source_id: "team-tranca-a",
      entity: @entity_a,
      category: @category,
      name: "Carlos / Ana"
    )

    @team_b = Team.create!(
      source_id: "team-tranca-b",
      entity: @entity_b,
      category: @category,
      name: "Pedro / Maria"
    )

    @invited_entity = Entity.create!(
      source_id: "entity-tranca-invited",
      name: "Dupla Convidada"
    )

    @invited_team = Team.create!(
      source_id: "tranca-invite-#{SecureRandom.hex(4)}",
      entity: @invited_entity,
      category: @category,
      name: "Convidada / Tranca"
    )

    @public_signup_entity = Entity.create!(
      source_id: "entity-tranca-public-signup",
      name: "Dupla Auto"
    )

    @public_signup_team = Team.create!(
      source_id: "team-tranca-public-signup",
      entity: @public_signup_entity,
      category: @category,
      name: "Auto / Cadastro"
    )

    @athlete_a = Athlete.create!(
      source_id: "athlete-tranca-a",
      team: @team_a,
      category: @category,
      name: "Carlos"
    )

    Athlete.create!(
      source_id: "athlete-tranca-b",
      team: @team_a,
      category: @category,
      name: "Ana"
    )

    Athlete.create!(
      source_id: "athlete-tranca-c",
      team: @team_b,
      category: @category,
      name: "Pedro"
    )

    Athlete.create!(
      source_id: "athlete-tranca-d",
      team: @team_b,
      category: @category,
      name: "Maria"
    )

    @live_match = Match.create!(
      source_id: "match-tranca-live",
      championship: @championship,
      category: @category,
      code: "T1",
      phase: "classificatoria",
      round_number: 3,
      status: :em_andamento,
      team_a: @team_a,
      team_b: @team_b
    )

    @recent_match = Match.create!(
      source_id: "match-tranca-recent",
      championship: @championship,
      category: @category,
      code: "T2",
      phase: "classificatoria",
      round_number: 2,
      status: :finalizado,
      score_a: 2,
      score_b: 1,
      team_a: @team_a,
      team_b: @team_b
    )

    @upcoming_match = Match.create!(
      source_id: "match-tranca-upcoming",
      championship: @championship,
      category: @category,
      code: "T3",
      phase: "classificatoria",
      round_number: 4,
      status: :agendado,
      team_a: @team_a,
      team_b: @team_b
    )

    StandingRow.create!(
      championship: @championship,
      category: @category,
      team: @team_a,
      position: 1,
      played: 2,
      wins: 2,
      draws: 0,
      losses: 0,
      goals_for: 4,
      goals_against: 1,
      goal_diff: 3,
      points: 6
    )

    StandingRow.create!(
      championship: @championship,
      category: @category,
      team: @team_b,
      position: 2,
      played: 2,
      wins: 0,
      draws: 0,
      losses: 2,
      goals_for: 1,
      goals_against: 4,
      goal_diff: -3,
      points: 0
    )
  end

  test "shows the tranca portal with its own layout" do
    get tranca_root_path

    assert_response :success
    assert_includes response.body, "Portal da Tranca"
    assert_includes response.body, 'data-theme="tranca"'
    assert_includes response.body, "CAMPEONATO DE TRANCA 2026"
  end

  test "uses the signed in user's theme instead of forcing the tranca palette" do
    user = users(:one)
    sign_in user

    %w[corporate flamengo atletico_mg].each do |theme|
      patch theme_preference_path, params: { theme_preference: { theme: theme } }
      assert_response :see_other

      get tranca_root_path

      assert_response :success
      assert_select "body[data-theme=?]", theme
      assert_select "form[action=?]", theme_preference_path, count: User::THEMES.size
    end
  end

  test "shows the tranca login page" do
    get tranca_login_path

    assert_response :success
    assert_includes response.body, "Entrar no portal tranca"
    assert_includes response.body, 'name="portal"'
    assert_includes response.body, 'value="tranca"'
  end

  test "redirects to the tranca portal after login" do
    post user_session_path, params: {
      portal: "tranca",
      user: {
        email: users(:one).email,
        password: "password123"
      }
    }

    assert_redirected_to tranca_root_path
  end

  test "shows the tranca championship dashboard inside the admin area" do
    sign_in users(:one)

    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Gestão da Tranca"
    assert_includes response.body, "Portal da Tranca"
    assert_includes response.body, "Duplas"
    assert_includes response.body, "Rodadas"
    assert_includes response.body, "Administração das duplas"
    assert_includes response.body, "Convidada"
    assert_includes response.body, "Auto cadastro"
    assert_includes response.body, @invited_team.name
    assert_includes response.body, @public_signup_team.name
  end

  test "shows the championship logo on tranca public pages" do
    @championship.logo.attach(
      fixture_file_upload("championship-logo.png", "image/png")
    )

    sign_in users(:one)

    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Logo do campeonato"
    assert_includes response.body, "/rails/active_storage"

    get classificacao_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Logo do campeonato"
    assert_includes response.body, "/rails/active_storage"
  end

  test "shows the mata-mata bracket when knockout rounds exist" do
    sign_in users(:one)

    suffix = SecureRandom.hex(3)
    dup_a = Tranca::Dupla.create!(
      source_id: "dupla-tranca-k1-a-#{suffix}",
      championship: @championship,
      category: @category,
      entity: @entity_a,
      name: "Chave A #{suffix}"
    )
    dup_b = Tranca::Dupla.create!(
      source_id: "dupla-tranca-k1-b-#{suffix}",
      championship: @championship,
      category: @category,
      entity: @entity_b,
      name: "Chave B #{suffix}"
    )
    dup_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-k1-c-#{suffix}",
      championship: @championship,
      category: @category,
      entity: @entity_a,
      name: "Chave C #{suffix}"
    )
    dup_d = Tranca::Dupla.create!(
      source_id: "dupla-tranca-k1-d-#{suffix}",
      championship: @championship,
      category: @category,
      entity: @entity_b,
      name: "Chave D #{suffix}"
    )

    Tranca::CompetitionFlow.new(@championship).generate_knockout_round!(round_number: 1)
    partida = @championship.tranca_partidas.where(phase: "mata_mata").order(:id).first
    patch update_tranca_partida_championship_path(@championship, partida_id: partida.id), params: {
      tranca_partida: {
        score_a: 12,
        score_b: 8,
        status: "finalizado",
        winner_id: dup_a.id
      }
    }

    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Dupla campeã"
    assert_includes response.body, "Chaveamento da Tranca"
    assert_includes response.body, "Dupla campeã"
    assert_includes response.body, partida.code
    assert_includes response.body, dup_a.name
  end

  test "shows the tranca duplas page" do
    sign_in users(:one)
    approved_team = Team.create!(
      source_id: "team-tranca-approved",
      entity: @entity_a,
      category: @category,
      name: "Confirmada / Exemplo",
      registration_status: :aprovada
    )

    get duplas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Duplas por categoria"
    assert_includes response.body, @team_a.name
    assert_includes response.body, @athlete_a.name
    assert_includes response.body, "Confirmado"
    assert_includes response.body, "Pendente"
    assert_includes response.body, approved_team.name
  end

  test "shows the tranca partidas page" do
    sign_in users(:one)

    get partidas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Mesas em andamento agora"
    assert_includes response.body, @live_match.code
    assert_includes response.body, @recent_match.code
    assert_includes response.body, @upcoming_match.code

    live_partida = Tranca::Partida.find_by!(source_id: @live_match.source_id)
    document = Nokogiri::HTML(response.body)
    link = document.at_xpath(%(.//a[@href="#{import_tranca_summula_championship_path(@championship, partida_id: live_partida.id)}"]))
    assert link.present?
  end

  test "shows only the complete summary download for finished tranca partidas" do
    sign_in users(:one)
    suffix = SecureRandom.hex(3)

    dupla_a = Tranca::Dupla.create!(
      source_id: "dupla-tranca-finished-a-#{suffix}",
      championship: @championship,
      category: @category,
      entity: @entity_a,
      name: "Completa A #{suffix}"
    )

    dupla_b = Tranca::Dupla.create!(
      source_id: "dupla-tranca-finished-b-#{suffix}",
      championship: @championship,
      category: @category,
      entity: @entity_b,
      name: "Completa B #{suffix}"
    )

    Tranca::Partida.create!(
      source_id: "partida-tranca-finished",
      championship: @championship,
      category: @category,
      code: "JG 99",
      phase: "classificatoria",
      round_number: 1,
      status: :finalizado,
      dupla_a: dupla_a,
      dupla_b: dupla_b,
      score_a: 1530,
      score_b: 1070,
      winner: dupla_a
    )

    get partidas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Baixar súmula completa"
  end

  test "shows the tranca rodadas page" do
    sign_in users(:one)

    get rodadas_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Rodadas"
    assert_includes response.body, "Rodada 2"
    assert_includes response.body, "Rodada 3"
  end

  test "shows the tranca classificacao page" do
    sign_in users(:one)

    get classificacao_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Tabela da Tranca"
    assert_includes response.body, @team_a.name
    assert_includes response.body, "PTS PRÓ"
    assert_includes response.body, "PTS CONTRA"
    assert_includes response.body, "SALDO"
  end

  test "creates a tranca duo from the management page" do
    sign_in users(:one)

    assert_difference -> { Team.where(category: @category).count }, 1 do
      post teams_path, params: {
        team: {
          entity_id: @entity_a.id,
          category_id: @category.id,
          name: "Nova Dupla"
        }
      }, headers: {
        "HTTP_REFERER" => duplas_championship_path(@championship)
      }
    end

    assert_redirected_to duplas_championship_path(@championship)
    team = Team.order(:created_at).last
    assert_equal "Nova Dupla", team.name
    assert team.registration_status_pendente?
  end

  test "creates a tranca duo with a new entity and suggested name" do
    sign_in users(:one)
    suffix = SecureRandom.hex(3)

    assert_difference -> { Entity.count }, 1 do
      assert_difference -> { Team.where(category: @category).count }, 1 do
        post teams_path, params: {
          team: {
            category_id: @category.id,
            participant_one_name: "Carlos #{suffix}",
            participant_two_name: "Ana #{suffix}"
          }
        }, headers: {
          "HTTP_REFERER" => duplas_championship_path(@championship)
        }
      end
    end

    assert_redirected_to duplas_championship_path(@championship)
    team = Team.order(:created_at).last
    assert_equal "Carlos #{suffix} / Ana #{suffix}", team.name
    assert_equal team.name, team.entity.name
    assert team.registration_status_pendente?
  end

  test "creates a tranca match from the management page" do
    sign_in users(:one)

    assert_difference -> { Match.where(championship: @championship).count }, 1 do
      post matches_path, params: {
        match: {
          championship_id: @championship.id,
          category_id: @category.id,
          team_a_id: @team_a.id,
          team_b_id: @team_b.id,
          phase: "classificatoria",
          round_number: 5,
          status: "agendado",
          code: "T4"
        }
      }, headers: {
        "HTTP_REFERER" => partidas_championship_path(@championship)
      }
    end

    assert_redirected_to partidas_championship_path(@championship)
    assert_equal "T4", Match.order(:created_at).last.code
  end

  test "creates and updates a tranca standing row" do
    sign_in users(:one)

    assert_difference -> { StandingRow.where(championship: @championship).count }, 1 do
      post standing_rows_path, params: {
        standing_row: {
          championship_id: @championship.id,
          category_id: @category.id,
          team_id: @team_a.id,
          group_key: "A",
          position: 3,
          played: 4,
          wins: 2,
          draws: 1,
          losses: 1,
          goals_for: 8,
          goals_against: 6,
          goal_diff: 2,
          points: 7,
          qualified: "1"
        }
      }, headers: {
        "HTTP_REFERER" => classificacao_championship_path(@championship)
      }
    end

    row = StandingRow.order(:created_at).last

    assert_redirected_to classificacao_championship_path(@championship)
    assert_equal 7, row.points

    patch standing_row_path(row), params: {
      standing_row: {
        championship_id: @championship.id,
        category_id: @category.id,
        team_id: @team_b.id,
        group_key: "A",
        position: 2,
        played: 5,
        wins: 3,
        draws: 1,
        losses: 1,
        goals_for: 10,
        goals_against: 7,
        goal_diff: 3,
        points: 10,
        qualified: "1"
      }
    }, headers: {
      "HTTP_REFERER" => classificacao_championship_path(@championship)
    }

    assert_redirected_to classificacao_championship_path(@championship)
    assert_equal 10, row.reload.points
    assert_equal @team_b, row.team
  end
end
