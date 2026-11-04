require "test_helper"

class RemainingAuthorizationSecurityTest < ActionDispatch::IntegrationTest
  setup do
    @manager = users(:two)
    sign_in @manager

    @championship = Championship.create!(
      source_id: "champ-remaining-auth-source",
      name: "Campeonato Origem",
      season: 2026
    )
    @category = Category.create!(
      source_id: "cat-remaining-auth-source",
      championship: @championship,
      name: "Sub 15"
    )
    @team = Team.create!(
      source_id: "team-remaining-auth-source",
      entity: Entity.create!(source_id: "entity-remaining-auth-source", name: "Clube Origem"),
      category: @category,
      name: "Equipe Origem"
    )
    TeamMembership.create!(
      source_id: "team-membership-remaining-auth",
      team: @team,
      user: @manager,
      role: :tecnico
    )
    ChampionshipMembership.create!(
      source_id: "champ-membership-remaining-auth",
      championship: @championship,
      user: @manager,
      role: :leitor
    )

    @other_championship = Championship.create!(
      source_id: "champ-remaining-auth-other",
      name: "Campeonato Destino",
      season: 2027
    )
    @other_category = Category.create!(
      source_id: "cat-remaining-auth-other",
      championship: @other_championship,
      name: "Sub 17"
    )
    @other_team = Team.create!(
      source_id: "team-remaining-auth-other",
      entity: Entity.create!(source_id: "entity-remaining-auth-other", name: "Clube Destino"),
      category: @other_category,
      name: "Equipe Destino"
    )
    @athlete = Athlete.create!(
      source_id: "athlete-remaining-auth",
      team: @team,
      category: @category,
      name: "Atleta Origem"
    )
    @match = Match.create!(
      source_id: "match-remaining-auth",
      championship: @championship,
      category: @category,
      code: "M-RA",
      phase: "grupos"
    )
  end

  teardown do
    @championship&.destroy!
    @other_championship&.destroy!
    Warden.test_reset!
  end

  test "a team manager cannot move their team into another championship category" do
    patch team_path(@team), params: { team: { category_id: @other_category.id } }, as: :json

    assert_response :forbidden
    assert_equal @category, @team.reload.category
  end

  test "a team manager cannot approve their own registration or change finance status" do
    patch team_path(@team), params: {
      team: { registration_status: "aprovada", finance_status: "pago" }
    }, as: :json

    assert_response :forbidden
    assert_not @team.reload.registration_status_aprovada?
    assert_not @team.finance_status_pago?
  end

  test "an open signup in the active championship cannot create a team in another championship" do
    @championship.update!(rules: { "registration" => { "team_signups" => { "enabled" => true } } })

    assert_no_difference -> { Team.count } do
      post teams_path, params: {
        team: {
          source_id: "team-remaining-auth-cross-create",
          entity_id: @team.entity_id,
          category_id: @other_category.id,
          name: "Equipe fora do escopo"
        }
      }, as: :json
    end

    assert_response :forbidden
  end

  test "a team manager cannot move an athlete or reassign its account" do
    patch athlete_path(@athlete), params: {
      athlete: {
        team_id: @other_team.id,
        category_id: @other_category.id,
        user_id: users(:one).id
      }
    }, as: :json

    assert_response :forbidden
    assert_equal @team, @athlete.reload.team
    assert_equal @category, @athlete.category
    assert_nil @athlete.user_id
  end

  test "a read-only championship member cannot edit or import a match" do
    get edit_match_path(@match)
    assert_response :forbidden

    patch match_path(@match), params: { match: { score_a: 9 } }, as: :json

    assert_response :forbidden
    assert_nil @match.reload.score_a

    post import_summula_match_path(@match), params: {
      match_summula_import: { confirm: "1", token: "forged" }
    }

    assert_response :forbidden
  end
end
