require "test_helper"

class AthleteReportTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)

    @championship = Championship.create!(
      source_id: "champ-athlete-report",
      name: "Campeonato Carteirinha",
      season: 2026,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-athlete-report",
      championship: @championship,
      name: "Sub 16"
    )

    @entity = Entity.create!(
      source_id: "entity-athlete-report",
      name: "Clube Carteirinha"
    )

    @team = Team.create!(
      source_id: "team-athlete-report",
      entity: @entity,
      category: @category,
      name: "Time Carteirinha"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-athlete-report",
      team: @team,
      category: @category,
      name: "Atleta Carteirinha",
      birth_date: Date.new(1993, 4, 2),
      shirt_number: "12",
      document: "732.310.312-19",
      cpf: "732.310.312-19",
      rg: "3.412.674-0",
      position: "Atacante",
      cell_phone: "(11) 99999-9999",
      email: "atleta@example.com",
      documents_count: 4,
      registration_submitted_at: Time.zone.local(2026, 10, 12, 17, 45)
    )
  end

  test "renders the athlete report page" do
    get athletes_path

    assert_response :success
    assert_includes response.body, "Lista de atletas"
    assert_includes response.body, "Atleta Carteirinha"
    assert_includes response.body, "Baixar exemplo PDF"
    assert_includes response.body, "Ver atleta"
    assert_includes response.body, "PDF"
  end

  test "renders the professional athlete card page" do
    get card_athlete_path(@athlete)

    assert_response :success
    assert_includes response.body, "Carteira de jogador"
    assert_includes response.body, "Resumo de performance"
    refute_includes response.body, "Baixar PDF"
    refute_includes response.body, "CPF"
    refute_includes response.body, @athlete.rg
  end

  test "renders athlete performance dashboard" do
    match = Match.create!(
      source_id: "match-athlete-report",
      championship: @championship,
      category: @category,
      code: "J1",
      phase: "grupos",
      status: :finalizado,
      score_a: 3,
      score_b: 1,
      team_a: @team,
      team_b: @team
    )

    match.match_participations.find_by!(team: @team, athlete: @athlete).update!(
      status: :confirmado
    )

    MatchEvent.create!(
      source_id: "match-event-athlete-report",
      match: match,
      team: @team,
      athlete: @athlete,
      kind: :gol
    )

    Suspension.create!(
      source_id: "susp-athlete-report",
      championship: @championship,
      category: @category,
      team: @team,
      athlete: @athlete,
      reason: "Cartão vermelho direto",
      status: :ativa
    )

    get athlete_path(@athlete)

    assert_response :success
    assert_includes response.body, "Performance"
    assert_includes response.body, "Jogos"
    assert_includes response.body, "Gols"
    assert_includes response.body, "Suspensões"
    assert_includes response.body, "Cartão vermelho direto"
    refute_includes response.body, "Baixar PDF"
    refute_includes response.body, "CPF"
    refute_includes response.body, @athlete.rg
    refute_includes response.body, @athlete.source_id
    refute_includes response.body, @athlete.user.email if @athlete.user.present?
  end

  test "renders a printable athlete card" do
    get card_athlete_path(@athlete)

    assert_response :success
    assert_includes response.body, "Atleta Carteirinha"
    assert_includes response.body, "Time Carteirinha"
    assert_includes response.body, "02/04/1993"
  end
end
