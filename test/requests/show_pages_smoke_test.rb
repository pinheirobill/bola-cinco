require "test_helper"

class ShowPagesSmokeTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    sign_in @admin

    @championship = Championship.create!(
      source_id: "champ-show-smoke",
      name: "Campeonato Smoke",
      season: 2027,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-show-smoke",
      championship: @championship,
      name: "Sub 20"
    )

    @entity = Entity.create!(
      source_id: "entity-show-smoke",
      name: "Associação Smoke"
    )

    @team_a = Team.create!(
      source_id: "team-show-smoke-a",
      entity: @entity,
      category: @category,
      name: "Equipe Smoke A"
    )

    @team_b = Team.create!(
      source_id: "team-show-smoke-b",
      entity: @entity,
      category: @category,
      name: "Equipe Smoke B"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-show-smoke",
      team: @team_a,
      category: @category,
      name: "Atleta Smoke",
      shirt_number: "10",
      position: "Ala",
      status: :validado
    )

    @venue = Venue.create!(
      source_id: "venue-show-smoke",
      championship: @championship,
      name: "Ginásio Smoke",
      city: "São Paulo",
      status: :ativo
    )

    @referee = Referee.create!(
      source_id: "ref-show-smoke",
      championship: @championship,
      name: "Árbitro Smoke",
      email: "arbitro@example.com",
      phone: "(11) 99999-9999",
      status: :ativo
    )

    @partner = Partner.create!(
      source_id: "partner-show-smoke",
      championship: @championship,
      name: "Parceiro Smoke",
      tier: :patrocinador,
      status: :ativo,
      highlight: true
    )

    @match = Match.create!(
      source_id: "match-show-smoke",
      championship: @championship,
      category: @category,
      venue: @venue,
      code: "S1",
      phase: "grupos",
      status: :finalizado,
      team_a: @team_a,
      team_b: @team_b,
      score_a: 3,
      score_b: 1,
      scheduled_on: Date.new(2027, 3, 18),
      scheduled_time: "19:30"
    )

    @match_report = MatchReport.create!(
      source_id: "report-show-smoke",
      match: @match,
      referee: @referee,
      status: :aprovado,
      notes: "Relatório de teste",
      sheet_url: "https://example.com/sumula.pdf",
      submitted_at: Time.zone.parse("2027-03-18 20:00"),
      approved_at: Time.zone.parse("2027-03-18 20:15")
    )

    @match_event = MatchEvent.create!(
      source_id: "event-show-smoke",
      championship: @championship,
      match: @match,
      team: @team_a,
      athlete: @athlete,
      kind: :gol,
      minute: 12,
      period: "1T",
      notes: "Gol de abertura"
    )

    @suspension = Suspension.create!(
      source_id: "suspension-show-smoke",
      championship: @championship,
      category: @category,
      team: @team_a,
      athlete: @athlete,
      match_event: @match_event,
      reason: "Cartão acumulado",
      status: :ativa,
      automatic: false,
      matches_count: 1,
      starts_on: Date.new(2027, 3, 19),
      notes: "Suspensão de teste"
    )

    @invoice = Invoice.create!(
      entity: @entity,
      championship: @championship,
      category: @category,
      amount: 125.5,
      due_date: Date.new(2027, 4, 1),
      status: :pendente
    )

    @tranca_championship = Championship.create!(
      source_id: "champ-tranca-show-smoke",
      name: "Campeonato Smoke Tranca",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )

    @tranca_category = Category.create!(
      source_id: "cat-tranca-show-smoke",
      championship: @tranca_championship,
      name: "Livre"
    )

    @tranca_entity = Entity.create!(
      source_id: "entity-tranca-show-smoke",
      name: "Dupla Smoke"
    )

    Tranca::Dupla.create!(
      source_id: "dupla-tranca-show-smoke-a",
      championship: @tranca_championship,
      category: @tranca_category,
      entity: @tranca_entity,
      name: "Carlos / Ana"
    )

    Tranca::Dupla.create!(
      source_id: "dupla-tranca-show-smoke-b",
      championship: @tranca_championship,
      category: @tranca_category,
      entity: @tranca_entity,
      name: "Pedro / Maria"
    )
  end

  test "renders the main show pages" do
    pages = [
      [root_path, "Bola Cinco"],
      [football_root_path, "Portal de Futebol"],
      [tranca_root_path, "Portal da Tranca"],
      [championship_path(@championship), @championship.name],
      [championship_path(@tranca_championship), @tranca_championship.name],
      [category_path(@category), @category.name],
      [entity_path(@entity), @entity.name],
      [team_path(@team_a), @team_a.name],
      [athlete_path(@athlete), @athlete.name],
      [venue_path(@venue), @venue.name],
      [referee_path(@referee), @referee.name],
      [partner_path(@partner), @partner.name],
      [match_path(@match), "Onboarding do jogo"],
      [match_report_path(@match_report), @match.code],
      [match_event_path(@match_event), @match_event.kind.humanize],
      [suspension_path(@suspension), @suspension.reason],
      [invoice_path(@invoice), @invoice.entity.name]
    ]

    pages.each do |path, expected|
      get path

      assert_response :success, "Expected #{path} to render successfully"
      assert_includes response.body, expected, "Expected #{path} to include #{expected.inspect}"
    end
  end
end
