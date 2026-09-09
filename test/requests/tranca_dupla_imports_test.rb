require "test_helper"
require_relative "../support/tranca_spreadsheet_helper"

class TrancaDuplaImportsTest < ActionDispatch::IntegrationTest
  include TrancaSpreadsheetHelper

  setup do
    @championship = Championship.create!(source_id: SecureRandom.uuid, name: "Tranca", season: 2026, modality: :tranca)
    @category = @championship.ensure_tranca_onboarding_category!
    sign_in users(:one)
  end
  teardown { cleanup_spreadsheets }

  test "preview requires confirmation and confirmed import is replay-safe" do
    assert_no_difference "Team.count" do
      post preview_championship_dupla_import_path(@championship), params: {
        category_id: @category.id, file: spreadsheet_upload([["Ana", "Bruno", ""]])
      }
      assert_response :success
    end
    token = css_select('input[name="token"]').first["value"]
    assert_difference "Team.count", 1 do
      post championship_dupla_import_path(@championship), params: { token: token }
      assert_response :success
    end
    assert @category.teams.last.registration_status_aprovada?
    assert_no_difference "Team.count" do
      post championship_dupla_import_path(@championship), params: { token: token }
      assert_response :success
    end
  end

  test "checks permissions for the form, template, preview and confirmation" do
    sign_in users(:two)
    get new_championship_dupla_import_path(@championship)
    assert_response :forbidden
    get template_championship_dupla_import_path(@championship)
    assert_response :forbidden
    post preview_championship_dupla_import_path(@championship)
    assert_response :forbidden
    post championship_dupla_import_path(@championship)
    assert_response :forbidden
  end

  test "rejects modified or foreign-championship tokens without writes" do
    verifier = Rails.application.message_verifier("tranca-duplas-import")
    token = verifier.generate({ "user_id" => users(:one).id, "championship_id" => -1,
      "category_id" => @category.id, "rows" => [] }, purpose: "tranca-duplas-import")
    [token, "modified-token"].each do |value|
      assert_no_difference "Team.count" do
        post championship_dupla_import_path(@championship), params: { token: value }
        assert_redirected_to new_championship_dupla_import_path(@championship)
      end
    end
  end

  test "serves the Excel template and reports invalid uploads" do
    get template_championship_dupla_import_path(@championship)
    assert_response :success
    assert_equal "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", response.media_type
    post preview_championship_dupla_import_path(@championship), params: { category_id: @category.id }
    assert_response :unprocessable_entity
    assert_includes response.body, "Selecione uma planilha"
  end
end
