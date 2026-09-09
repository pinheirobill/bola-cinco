require "test_helper"
require_relative "../../support/tranca_spreadsheet_helper"

class Tranca::DuplasSpreadsheetTest < ActiveSupport::TestCase
  include TrancaSpreadsheetHelper
  teardown { cleanup_spreadsheets }

  test "reads inline and shared strings without changing names" do
    [false, true].each do |shared|
      upload = spreadsheet_upload([["Luíza", "Ana", ""]], shared: shared)
      result = Tranca::DuplasSpreadsheet.read(upload)
      assert_equal 1, result.size
      assert_equal "Luíza", result.first["participant_one"]
      assert_equal "Ana", result.first["participant_two"]
      assert_equal 2, result.first["line"]
    end
  end

  test "skips empty rows and flags formulas" do
    upload = spreadsheet_upload([["", "", ""], ["Ana", "Bruno", ""]])
    assert_equal [3], Tranca::DuplasSpreadsheet.read(upload).pluck("line")
    formula = spreadsheet_upload([["Ana", "Bruno", ""]], formulas: true)
    assert Tranca::DuplasSpreadsheet.read(formula).first["file_error"].present?
  end

  test "rejects missing file, invalid headers, and more than 500 pairs" do
    assert_raises(Tranca::DuplasSpreadsheet::InvalidFile) { Tranca::DuplasSpreadsheet.read(nil) }
    assert_raises(Tranca::DuplasSpreadsheet::InvalidFile) do
      Tranca::DuplasSpreadsheet.read(spreadsheet_upload([["Ana", "Bruno", ""]], headers: ["Errado", "", ""]))
    end
    assert_raises(Tranca::DuplasSpreadsheet::InvalidFile) do
      Tranca::DuplasSpreadsheet.read(spreadsheet_upload(Array.new(501) { ["Ana", "Bruno", ""] }))
    end
  end

  test "downloadable template has valid headers and no fictional registrations" do
    error = assert_raises(Tranca::DuplasSpreadsheet::InvalidFile) do
      Tranca::DuplasSpreadsheet.new(Rails.root.join("lib/templates/tranca_duplas.xlsx")).rows
    end
    assert_match(/vazia/, error.message)
  end
end
