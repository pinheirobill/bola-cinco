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
    assert_includes response.body, "Importar equipes"

    spreadsheet = roster_spreadsheet_upload([
      [ "Equipe Alfa", "10", "Carlos Silva", "123.456", "", "01/01/1990" ],
      [ "Equipe Alfa", "11", "João Pedro", "", "", "02/02/1991" ]
    ])

    assert_difference "Team.count", 1 do
      assert_difference "Athlete.count", 1 do
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
