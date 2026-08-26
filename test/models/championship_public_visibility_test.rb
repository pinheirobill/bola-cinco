require "test_helper"

class ChampionshipPublicVisibilityTest < ActiveSupport::TestCase
  test "generates a slug on create" do
    championship = Championship.create!(
      source_id: "champ-public-1",
      name: "Copa Portal",
      season: 2026
    )

    assert_equal "copa-portal-2026", championship.slug
    refute_predicate championship, :publicly_visible?
  end

  test "marks active championships as publicly visible" do
    championship = Championship.create!(
      source_id: "champ-public-2",
      name: "Copa Aberta",
      season: 2026,
      status: :em_andamento
    )

    assert_predicate championship, :publicly_visible?
  end
end
