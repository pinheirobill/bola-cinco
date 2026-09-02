require "test_helper"
require "securerandom"

class MatchParticipationsTest < ActionDispatch::IntegrationTest
  setup do
    @suffix = SecureRandom.hex(4)
    @user = users(:one)
    sign_in @user

    @championship = Championship.create!(
      source_id: "champ-match-participation-#{@suffix}",
      name: "Campeonato Participação",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-match-participation-#{@suffix}",
      championship: @championship,
      name: "Sub 18"
    )

    @team = Team.create!(
      source_id: "team-match-participation-#{@suffix}",
      entity: Entity.create!(source_id: "entity-match-participation-#{@suffix}", name: "Equipe Participação"),
      category: @category,
      name: "Equipe Participação"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-match-participation-#{@suffix}",
      team: @team,
      category: @category,
      name: "Atleta Participação"
    )

    @match = Match.create!(
      source_id: "match-match-participation-#{@suffix}",
      championship: @championship,
      category: @category,
      code: "M-#{@suffix}",
      phase: "grupos"
    )

    @participation = MatchParticipation.create!(
      source_id: "match-participation-#{@suffix}",
      match: @match,
      team: @team,
      athlete: @athlete,
      athlete_name: @athlete.name,
      status: :pendente
    )
  end

  teardown do
    @championship&.destroy!
    Warden.test_reset!
  end

  test "updates participation status through autosave json" do
    patch match_participation_path(@participation),
      params: {
        autosave: "1",
        match_participation: {
          status: "confirmado"
        }
      },
      as: :json

    assert_response :success

    payload = JSON.parse(response.body)
    assert_equal @participation.id, payload["id"]
    assert_equal "confirmado", payload["status"]
    assert_equal match_participation_path(@participation), payload["update_url"]
    assert_equal "confirmado", @participation.reload.status

    patch match_participation_path(@participation),
      params: {
        autosave: "1",
        match_participation: {
          status: "ausente"
        }
      },
      as: :json

    assert_response :success
    assert_equal "ausente", JSON.parse(response.body)["status"]
    assert_equal "ausente", @participation.reload.status
  end
end
