require "test_helper"

class PublicPortalTest < ActionDispatch::IntegrationTest
  setup do
    @draft_championship = Championship.create!(
      source_id: "champ-draft-public",
      name: "Campeonato Rascunho",
      season: 2027
    )

    @championship = Championship.create!(
      source_id: "champ-public-portal",
      name: "Campeonato Portal",
      season: 2026,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-public-portal",
      championship: @championship,
      name: "Sub 18"
    )

    @entity = Entity.create!(
      source_id: "entity-public-portal",
      name: "Escola Portal"
    )

    @team = Team.create!(
      source_id: "team-public-portal",
      entity: @entity,
      category: @category,
      name: "Time Portal"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-public-portal",
      team: @team,
      category: @category,
      name: "Atleta Portal"
    )

    @match = Match.create!(
      source_id: "match-public-portal",
      championship: @championship,
      category: @category,
      code: "J1",
      phase: "grupos",
      status: :finalizado,
      score_a: 3,
      score_b: 2,
      team_a: @team,
      team_b: @team
    )

    StandingRow.create!(
      championship: @championship,
      category: @category,
      team: @team,
      position: 1,
      played: 1,
      wins: 1,
      draws: 0,
      losses: 0,
      goals_for: 3,
      goals_against: 2,
      goal_diff: 1,
      points: 3
    )

    @championship.partners.create!(
      source_id: "partner-public-portal",
      name: "Parceiro Portal",
      status: :ativo,
      highlight: true
    )
  end

  test "shows the public home page and ignores newer drafts" do
    get root_path

    assert_response :success
    assert_includes response.body, "Campeonato Portal"
    refute_includes response.body, "Campeonato Rascunho"
  end

  test "shows a public championship by friendly slug" do
    assert_includes championship_path(@championship), @championship.slug

    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Campeonato Portal"
    assert_includes response.body, "Top atletas"
    assert_includes response.body, "Inscrição de equipes"
    assert_includes response.body, "championship-team-signup-modal"
    assert_includes response.body, "Inscrições de equipes"
    assert_includes response.body, "Quantidade de chaves"
    assert_includes response.body, "Classificados por chave"
    assert_includes response.body, @team.name
  end

  test "admin can confirm all pending team registrations from the championship page" do
    sign_in users(:one)

    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Confirmar todos"

    patch confirm_all_team_registrations_championship_path(@championship)

    assert_redirected_to championship_path(@championship)
    assert @team.reload.registration_status_aprovada?
  end

  test "shows team status editor to admins on the championship page" do
    sign_in users(:one)

    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Aprovada"
    assert_includes response.body, "Finalizar inscrições"
    refute_includes response.body, "Salvar"
  end

  test "admin can edit a team registration status inline from the championship page" do
    sign_in users(:one)

    patch team_path(@team), params: {
      team: {
        registration_status: "aprovada"
      }
    }, headers: {
      "HTTP_REFERER" => championship_path(@championship)
    }

    assert_redirected_to championship_path(@championship)
    assert @team.reload.registration_status_aprovada?
  end

  test "scopes public team, athlete and standings pages to the current championship" do
    get team_path(@team)
    assert_response :success
    assert_includes response.body, "Time Portal"
    assert_includes response.body, @championship.name
    assert_includes response.body, championship_path(@championship)
    assert_includes response.body, match_path(@match)
    assert_includes response.body, athlete_path(@athlete)

    get athlete_path(@athlete)
    assert_response :success
    assert_includes response.body, "Atleta Portal"

    get standing_rows_path
    assert_response :success
    assert_includes response.body, "Time Portal"
  end

  test "shows the internal portal section for signed in users" do
    sign_in users(:one)

    get root_path

    assert_response :success
    assert_includes response.body, "Área interna"
    assert_includes response.body, "Campeonatos acessíveis"
    assert_includes response.body, "Próximos jogos"
  end

  test "redirects the legacy dashboard path to the portal" do
    get dashboard_path

    assert_redirected_to root_path
  end
end
