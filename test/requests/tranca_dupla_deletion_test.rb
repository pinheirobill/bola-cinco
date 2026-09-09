require "test_helper"

class TrancaDuplaDeletionTest < ActionDispatch::IntegrationTest
  test "refuses to delete a primary team without removing its mirror or members" do
    championship = Championship.create!(source_id: SecureRandom.uuid, name: "Tranca", season: 2026, modality: :tranca)
    category = championship.ensure_tranca_onboarding_category!
    Tranca::DuplasImport.new(championship: championship, category: category, rows: [
      { "line" => 2, "participant_one" => "Ana", "participant_two" => "Bruno", "name" => "" }
    ]).call
    team = category.teams.last
    sign_in users(:one)

    assert_no_difference ["Team.count", "Athlete.count", "TeamAthlete.count", "Tranca::Dupla.count", "Tranca::DuplaMembership.count"] do
      delete team_path(team)
      assert_redirected_to team_path(team)
    end
    assert_includes flash[:alert], "cadastro principal"
  end
end
