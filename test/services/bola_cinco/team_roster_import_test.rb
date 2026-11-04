require "test_helper"
require_relative "../../support/team_roster_spreadsheet_helper"

class BolaCinco::TeamRosterImportTest < ActiveSupport::TestCase
  include TeamRosterSpreadsheetHelper

  setup do
    @championship = Championship.create!(source_id: SecureRandom.uuid, name: "Fut 2026", season: 2026, modality: :football)
    @category = Category.create!(source_id: SecureRandom.uuid, championship: @championship, name: "Adulto")
  end

  teardown { cleanup_spreadsheets }

  test "creates a team from the spreadsheet and reuses athletes by rg" do
    external_championship = Championship.create!(source_id: SecureRandom.uuid, name: "Outro", season: 2026, modality: :football)
    external_category = Category.create!(source_id: SecureRandom.uuid, championship: external_championship, name: "Outra")
    external_entity = Entity.create!(source_id: SecureRandom.uuid, name: "Equipe antiga")
    external_team = Team.create!(
      source_id: SecureRandom.uuid,
      entity: external_entity,
      category: external_category,
      name: "Equipe antiga",
      registration_status: :aprovada,
      finance_status: :pago
    )
    existing_athlete = Athlete.create!(
      source_id: SecureRandom.uuid,
      team: external_team,
      category: external_category,
      name: "Carlos Silva",
      rg: "123456",
      status: :validado
    )

    result = service([
      [ "Equipe Alfa", "10", "Carlos Silva", "123.456", "", "01/01/1990" ],
      [ "Equipe Alfa", "11", "João Pedro", "", "", "02/02/1991" ]
    ]).call

    assert_equal ["create"], result.map { |entry| entry[:action] }
    team = @category.teams.find_by!(name: "Equipe Alfa")
    assert_equal team.id, existing_athlete.reload.team_id
    assert_equal @category.id, existing_athlete.reload.category_id
    assert_equal 2, team.athletes.count
    assert_equal 1, team.team_athletes.where(athlete: existing_athlete).count
  end

  test "creates a new athlete when only the name matches" do
    external_championship = Championship.create!(source_id: SecureRandom.uuid, name: "Outro", season: 2026, modality: :football)
    external_category = Category.create!(source_id: SecureRandom.uuid, championship: external_championship, name: "Outra")
    external_team = Team.create!(
      source_id: SecureRandom.uuid,
      entity: Entity.create!(source_id: SecureRandom.uuid, name: "Equipe externa"),
      category: external_category,
      name: "Equipe externa",
      registration_status: :aprovada,
      finance_status: :pago
    )
    Athlete.create!(
      source_id: SecureRandom.uuid,
      team: external_team,
      category: external_category,
      name: "Igor Santos",
      status: :validado
    )

    assert_difference "Athlete.count", 1 do
      result = service([[ "Equipe Beta", "7", "Igor Santos", "", "", "03/03/1992" ]]).call
      assert_equal "create", result.first[:athletes].first[:action]
    end
  end

  test "is idempotent on repeated imports" do
    rows = [[ "Equipe Gama", "9", "Ana Costa", "888", "", "04/04/1993" ]]
    assert_difference ["Team.count", "Athlete.count"], 1 do
      service(rows).call
    end
    assert_no_difference ["Team.count", "Athlete.count"] do
      service(rows).call
    end
  end

  test "imports optional athlete registration fields" do
    headers = %w[equipe nome email celular certidao_de_nascimento posicao passaporte titulo_de_eleitor genero documento]
    rows = ["Equipe Delta", "Marina Souza", "marina@example.test", "11999999999", "cert-1", "Defesa", "pass-1", "titulo-1", "feminino", "doc-1"]
    spreadsheet = roster_spreadsheet_upload([rows], headers: headers)
    parsed_rows = BolaCinco::TeamRosterSpreadsheet.read(spreadsheet)

    service(parsed_rows).call
    athlete = @category.athletes.find_by!(name: "Marina Souza")

    assert_equal "marina@example.test", athlete.email
    assert_equal "11999999999", athlete.cell_phone
    assert_equal "cert-1", athlete.birth_certificate
    assert_equal "Defesa", athlete.position
    assert_equal "pass-1", athlete.passport
    assert_equal "titulo-1", athlete.voter_id
    assert_equal "feminino", athlete.gender
    assert_equal "doc-1", athlete.document
  end

  test "accepts a category shared with the selected championship" do
    shared_championship = Championship.create!(source_id: SecureRandom.uuid, name: "Outro campeonato", season: 2026, modality: :football)
    @category.championship_categories.create!(source_id: SecureRandom.uuid, championship: shared_championship)

    assert_difference "Team.count", 1 do
      service([["Equipe Compartilhada", "8", "Lucas Silva", "", "", ""]], championship: shared_championship).call
    end
  end

  test "imports an athlete roster into an existing team without moving a matching rg from another team" do
    target_team = create_team("Equipe Alvo")
    external_category = Category.create!(source_id: SecureRandom.uuid, championship: Championship.create!(source_id: SecureRandom.uuid, name: "Externo", season: 2026), name: "Outra categoria")
    external_team = create_team("Equipe Externa", category: external_category)
    external_athlete = Athlete.create!(source_id: SecureRandom.uuid, team: external_team, category: external_category, name: "Carlos Silva", rg: "123456")
    rows = [{ "line" => 2, "athlete_name" => "Carlos Silva", "rg" => "123.456", "email" => "carlos@example.test" }]

    assert_difference "Athlete.count", 1 do
      BolaCinco::TeamRosterImport.new(championship: @championship, category: @category, target_team: target_team, rows: rows).call
    end

    imported_athlete = target_team.athletes.find_by!(rg: "123456")
    assert_equal "carlos@example.test", imported_athlete.email
    assert_equal external_team.id, external_athlete.reload.team_id
  end

  private

  def service(rows, championship: @championship)
    BolaCinco::TeamRosterImport.new(championship: championship, category: @category, rows: rows)
  end

  def create_team(name, category: @category)
    Team.create!(
      source_id: SecureRandom.uuid,
      entity: Entity.create!(source_id: SecureRandom.uuid, name: name),
      category: category,
      name: name,
      registration_status: :aprovada,
      finance_status: :pendente
    )
  end
end
