require "test_helper"

class PartnerTest < ActiveSupport::TestCase
  test "defaults to active partner tier" do
    championship = Championship.create!(
      source_id: "champ-partner",
      name: "Campeonato Parceiro",
      season: 2026
    )

    partner = Partner.create!(
      source_id: "partner-1",
      championship: championship,
      name: "Marca 1"
    )

    assert partner.status_ativo?
    assert partner.tier_parceiro?
  end
end
