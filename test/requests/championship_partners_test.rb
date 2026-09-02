require "test_helper"

class ChampionshipPartnersTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)

    @championship = Championship.create!(
      source_id: "champ-partners-main",
      name: "Campeonato Parceiros",
      season: 2026,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-champ-partners",
      championship: @championship,
      name: "Sub 18"
    )

    @featured_partner = @championship.partners.create!(
      source_id: "partner-featured-main",
      name: "Parceiro Principal",
      status: :ativo,
      highlight: true,
      tier: :patrocinador
    )

    other_championship = Championship.create!(
      source_id: "champ-partners-source",
      name: "Campeonato Origem",
      season: 2025,
      status: :em_andamento
    )

    @available_partner = other_championship.partners.create!(
      source_id: "partner-source-copy",
      name: "Parceiro para Copiar",
      status: :ativo,
      highlight: false,
      tier: :apoiador,
      website_url: "https://example.com"
    )
  end

  test "shows the partner manager on the championship page" do
    get championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Criar parceiro"
    assert_includes response.body, "Gerenciar"
    assert_includes response.body, "Gerenciar parceiros"
    assert_includes response.body, "Acesso rápido"
    assert_includes response.body, "Adicionar ao campeonato"
    assert_includes response.body, @featured_partner.name
    assert_includes response.body, @available_partner.name
  end

  test "copies an existing partner into the championship" do
    assert_difference -> { @championship.reload.partners.count }, 1 do
      patch attach_partner_championship_path(@championship), params: { partner_id: @available_partner.id }
    end

    assert_redirected_to championship_path(@championship)

    copied_partner = @championship.reload.partners.order(:created_at).last
    assert_equal @available_partner.name, copied_partner.name
    assert_equal @available_partner.website_url, copied_partner.website_url
    assert copied_partner.highlight?
    assert_equal @available_partner.tier, copied_partner.tier
    assert_equal @available_partner.status, copied_partner.status
  end
end
