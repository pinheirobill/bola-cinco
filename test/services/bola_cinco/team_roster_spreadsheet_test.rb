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
    assert_equal "01/01/1990", rows.first["birth_date"]
  end
end
