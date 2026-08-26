require "test_helper"

class ChampionshipMembershipTest < ActiveSupport::TestCase
  test "defaults to active organizer role" do
    user = User.create!(
      email: "organizer@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :adm_master
    )

    championship = Championship.create!(
      source_id: "championship-membership-test",
      name: "Campeonato Membership",
      season: 2026
    )

    membership = ChampionshipMembership.create!(
      source_id: "championship-membership-1",
      championship: championship,
      user: user
    )

    assert membership.status_ativo?
    assert membership.role_organizador?
  end
end
