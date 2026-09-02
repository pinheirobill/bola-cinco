require "test_helper"

class ChampionshipModalityTest < ActiveSupport::TestCase
  test "defaults championships to football modality" do
    championship = Championship.create!(
      source_id: "champ-modality-default",
      name: "Copa Base",
      season: 2026
    )

    assert_predicate championship, :football?
    assert_equal "Futebol", championship.modality_label
  end

  test "allows tranca modality" do
    championship = Championship.create!(
      source_id: "champ-modality-tranca",
      name: "Copa Tranca",
      season: 2026,
      modality: :tranca
    )

    assert_predicate championship, :tranca?
    assert_equal "Tranca", championship.modality_label
  end
end
