require "test_helper"

class AutosaveFormsTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)

    @championship = Championship.create!(
      source_id: "autosave-championship-#{SecureRandom.hex(4)}",
      name: "Campeonato Autosave",
      season: 2026
    )

    @category = Category.create!(
      source_id: "autosave-category-#{SecureRandom.hex(4)}",
      championship: @championship,
      name: "Sub 11"
    )

    @entity = Entity.create!(
      source_id: "autosave-entity-#{SecureRandom.hex(4)}",
      name: "Escola Autosave"
    )

    @team = Team.create!(
      source_id: "autosave-team-#{SecureRandom.hex(4)}",
      entity: @entity,
      category: @category,
      name: "Time Autosave"
    )

    @athlete = Athlete.create!(
      source_id: "autosave-athlete-#{SecureRandom.hex(4)}",
      team: @team,
      category: @category,
      name: "Atleta Autosave"
    )
  end

  test "autosaves venue edits without redirecting" do
    venue = Venue.create!(
      source_id: "autosave-venue-#{SecureRandom.hex(4)}",
      name: "Campo Antigo"
    )

    patch venue_path(venue), params: {
      autosave: "1",
      venue: {
        name: "Campo Novo",
        short_name: "CN",
        city: "São Paulo",
        address: "Rua 1",
        notes: "Atualizado",
        status: "ativo"
      }
    }

    assert_response :no_content
    assert_equal "Campo Novo", venue.reload.name
  end

  test "autosaves referee edits without redirecting" do
    referee = Referee.create!(
      source_id: "autosave-referee-#{SecureRandom.hex(4)}",
      name: "Árbitro Antigo"
    )

    patch referee_path(referee), params: {
      autosave: "1",
      referee: {
        name: "Árbitro Novo",
        status: "ativo",
        email: "arbitro@bola-cinco.local",
        phone: "(11) 99999-0000",
        document: "123456",
        notes: "Atualizado"
      }
    }

    assert_response :no_content
    assert_equal "Árbitro Novo", referee.reload.name
  end

  test "autosaves partner edits without redirecting" do
    partner = Partner.create!(
      source_id: "autosave-partner-#{SecureRandom.hex(4)}",
      championship: @championship,
      category: @category,
      name: "Parceiro Antigo",
      tier: :parceiro,
      status: :ativo
    )

    patch partner_path(partner), params: {
      autosave: "1",
      partner: {
        name: "Parceiro Novo",
        tier: "patrocinador",
        status: "ativo",
        category_id: @category.id,
        logo_url: "https://example.com/logo.png",
        website_url: "https://example.com",
        highlight: "1",
        notes: "Atualizado"
      }
    }

    assert_response :no_content
    assert_equal "Parceiro Novo", partner.reload.name
    assert partner.reload.highlight?
  end

  test "autosaves suspension edits without redirecting" do
    suspension = Suspension.create!(
      source_id: "autosave-suspension-#{SecureRandom.hex(4)}",
      championship: @championship,
      athlete: @athlete,
      reason: "Cartão vermelho",
      status: :ativa,
      automatic: false,
      matches_count: 1
    )

    patch suspension_path(suspension), params: {
      autosave: "1",
      suspension: {
        reason: "Atualizado",
        status: "cumprida",
        automatic: "1",
        matches_count: 2,
        notes: "Observação"
      }
    }

    assert_response :no_content
    assert_equal "Atualizado", suspension.reload.reason
    assert_equal "cumprida", suspension.reload.status
  end
end
