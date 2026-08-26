require "test_helper"

class CategorySharingTest < ActiveSupport::TestCase
  test "category can be linked to multiple championships" do
    first = Championship.create!(
      source_id: "championship-#{SecureRandom.hex(4)}",
      name: "Primeiro campeonato",
      season: 2026
    )
    second = Championship.create!(
      source_id: "championship-#{SecureRandom.hex(4)}",
      name: "Segundo campeonato",
      season: 2027
    )

    category = Category.create!(
      source_id: "category-#{SecureRandom.hex(4)}",
      championship: first,
      name: "Sub 11"
    )

    second.categories << category

    assert_equal [first.id, second.id].sort, category.reload.championships.pluck(:id).sort
    assert_includes first.reload.categories, category
    assert_includes second.reload.categories, category
  end
end
