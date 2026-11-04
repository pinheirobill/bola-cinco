require "test_helper"
require_relative "../../support/team_roster_spreadsheet_helper"

class BolaCinco::TeamRosterSpreadsheetTest < ActiveSupport::TestCase
  include TeamRosterSpreadsheetHelper

  teardown { cleanup_spreadsheets }

  test "accepts the expected headers with D.Nascimento" do
    spreadsheet = roster_spreadsheet_upload([
      [ "Equipe Alfa", "10", "Carlos Silva", "123.456", "", "01/01/1990" ]
    ])

    rows = BolaCinco::TeamRosterSpreadsheet.read(spreadsheet)

    assert_equal 1, rows.size
    assert_equal "Equipe Alfa", rows.first["team_name"]
    assert_equal "1990-01-01", rows.first["birth_date"]
  end

  test "reads optional athlete fields by header regardless of their column order" do
    spreadsheet = roster_spreadsheet_upload(
      [["Carlos Silva", "carlos@example.test", "Equipe Alfa", "01/01/1990", "Goleiro"]],
      headers: ["nome", "email", "equipe", "data_nascimento", "posição"]
    )

    row = BolaCinco::TeamRosterSpreadsheet.read(spreadsheet).first

    assert_equal "Equipe Alfa", row["team_name"]
    assert_equal "Carlos Silva", row["athlete_name"]
    assert_equal "carlos@example.test", row["email"]
    assert_equal "1990-01-01", row["birth_date"]
    assert_equal "Goleiro", row["position"]
  end

  test "allows a team roster file without a team column when the target team is known" do
    spreadsheet = roster_spreadsheet_upload(
      [["Carlos Silva", "carlos@example.test", "01/01/1990"]],
      headers: ["nome", "email", "data_nascimento"]
    )

    row = BolaCinco::TeamRosterSpreadsheet.read(spreadsheet, require_team: false).first

    assert_equal "", row["team_name"]
    assert_equal "Carlos Silva", row["athlete_name"]
    assert_equal "carlos@example.test", row["email"]
  end
end
