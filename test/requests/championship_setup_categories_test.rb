require "test_helper"

class ChampionshipSetupCategoriesTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @championship = Championship.create!(
      source_id: "champ-master-cup-template",
      name: "MASTER CUP 2026",
      season: 2026
    )
  end

  test "creates the four Master Cup categories and their category-specific formats" do
    assert_difference("Category.count", 4) do
      post create_mastercup_categories_championship_path(@championship)
    end

    assert_redirected_to setup_championship_path(@championship, step: "format")
    formats = @championship.reload.format_data.fetch("categoryFormats")
    categories = @championship.categories.index_by(&:name)

    assert_equal 4, categories.size
    assert_equal [6, 2, "cross_groups", 0], %w[teamCount groupCount schedule matchesPerTeam].map { |key| formats.fetch(categories.fetch("Pré Mirim").id.to_s).fetch(key) }
    assert_equal [6, 2, "cross_groups", 0], %w[teamCount groupCount schedule matchesPerTeam].map { |key| formats.fetch(categories.fetch("Mirim").id.to_s).fetch(key) }
    assert_equal [4, 1, "within_groups", 0], %w[teamCount groupCount schedule matchesPerTeam].map { |key| formats.fetch(categories.fetch("Infantil").id.to_s).fetch(key) }
    assert_equal [3, 1, "within_groups", "melhor_campanha_final"], [
      formats.fetch(categories.fetch("Juvenil").id.to_s).fetch("teamCount"),
      formats.fetch(categories.fetch("Juvenil").id.to_s).fetch("groupCount"),
      formats.fetch(categories.fetch("Juvenil").id.to_s).fetch("schedule"),
      formats.fetch(categories.fetch("Juvenil").id.to_s).fetch("mode")
    ]
  end

  test "creates and links an individual category from the championship setup" do
    assert_difference("Category.count", 1) do
      post create_category_championship_path(@championship), params: { category: { name: "Sub 15" } }
    end

    assert_redirected_to setup_championship_path(@championship, step: "teams")
    assert @championship.categories.exists?(name: "Sub 15")
  end
end
