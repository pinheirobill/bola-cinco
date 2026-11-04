require "test_helper"
require_relative "../support/team_roster_spreadsheet_helper"

class ChampionshipTeamImportsTest < ActionDispatch::IntegrationTest
  include TeamRosterSpreadsheetHelper

  setup do
    @championship = Championship.create!(source_id: SecureRandom.uuid, name: "Fut 2026", season: 2026, modality: :football)
    @category = Category.create!(source_id: SecureRandom.uuid, championship: @championship, name: "Adulto")
    sign_in users(:one)
  end

  teardown { cleanup_spreadsheets }

  test "shows the import form and imports spreadsheet rows" do
    get new_championship_team_import_path(@championship)
    assert_response :success
    assert_includes response.body, "Importar equipes e atletas"
    assert_includes response.body, "D.Nascimento"

    spreadsheet = roster_spreadsheet_upload([
      [ "Equipe Alfa", "10", "Carlos Silva", "123.456", "", "01/01/1990" ],
      [ "Equipe Alfa", "11", "João Pedro", "", "", "02/02/1991" ]
    ])

    assert_difference "Team.count", 1 do
      assert_difference "Athlete.count", 2 do
        post championship_team_import_path(@championship), params: {
          team_import: {
            category_id: @category.id,
            file: spreadsheet
          }
        }
        assert_redirected_to championship_path(@championship)
      end
    end

    team = @category.teams.find_by!(name: "Equipe Alfa")
    assert_equal 2, team.athletes.count
    assert_equal "Carlos Silva", team.athletes.find_by(rg: "123456")&.name
  end

  test "offers the existing import from an empty category and returns to it after import" do
    get category_path(@category)
    assert_response :success
    assert_includes response.body, "Importar equipes e atletas do Excel"

    get new_championship_team_import_path(@championship, category_id: @category.id, return_to_category: "1")
    assert_response :success
    assert_select "select[name='team_import[category_id]'] option[selected]", text: "Adulto"

    spreadsheet = roster_spreadsheet_upload([["Equipe Alfa", "10", "Carlos Silva", "", "", "", "carlos@example.test"]], headers: %w[equipe numero nome RG CPF D.Nascimento email])
    post championship_team_import_path(@championship), params: {
      team_import: { category_id: @category.id, return_to_category: "1", file: spreadsheet }
    }

    assert_redirected_to category_path(@category)
    assert_equal "carlos@example.test", @category.athletes.find_by!(name: "Carlos Silva").email
  end

  test "imports an optional roster spreadsheet directly into the selected team" do
    entity = Entity.create!(source_id: SecureRandom.uuid, name: "Equipe fixa")
    team = Team.create!(source_id: SecureRandom.uuid, entity: entity, category: @category, name: "Equipe fixa")

    get team_path(team)
    assert_response :success
    assert_includes response.body, "Cadastrar atleta rapidamente"
    assert_includes response.body, "Importar atletas"

    get new_championship_team_import_path(@championship, category_id: @category.id, team_id: team.id)
    assert_response :success
    assert_includes response.body, "Importar atletas"
    assert_includes response.body, "Os atletas serão adicionados a Equipe fixa."

    spreadsheet = roster_spreadsheet_upload(
      [["Marina Souza", "marina@example.test", "05/03/2010"]],
      headers: %w[nome email data_nascimento]
    )

    assert_no_difference "Team.count" do
      assert_difference "Athlete.count", 1 do
        post championship_team_import_path(@championship), params: {
          team_import: { category_id: @category.id, team_id: team.id, file: spreadsheet }
        }
        assert_response :redirect
      end
    end

    assert_redirected_to team_path(team)
    athlete = team.athletes.find_by!(name: "Marina Souza")
    assert_equal "marina@example.test", athlete.email
    assert_equal Date.new(2010, 3, 5), athlete.birth_date
  end

  test "requires manageability and a valid spreadsheet" do
    sign_in users(:two)
    get new_championship_team_import_path(@championship)
    assert_response :forbidden

    sign_in users(:one)
    post championship_team_import_path(@championship), params: {
      team_import: {
        category_id: @category.id,
        file: nil
      }
    }
    assert_response :unprocessable_entity
    assert_includes response.body, "Selecione uma planilha"
  end
end
