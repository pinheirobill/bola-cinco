require "test_helper"
require "tempfile"

class BolaCincoImporterTest < ActiveSupport::TestCase
  test "links imported categories to the championship and scopes standings per category" do
    payload = {
      "championship" => {
        "id" => "championship-import-test",
        "name" => "Campeonato Importado",
        "season" => 2026,
        "status" => "em_andamento"
      },
      "categories" => [
        { "id" => "category-a", "name" => "Sub 11" },
        { "id" => "category-b", "name" => "Sub 13" }
      ],
      "entities" => [
        { "id" => "entity-a", "name" => "Entidade Teste" }
      ],
      "teams" => [
        { "id" => "team-a-1", "entityId" => "entity-a", "categoryId" => "category-a", "name" => "Time A1" },
        { "id" => "team-a-2", "entityId" => "entity-a", "categoryId" => "category-a", "name" => "Time A2" },
        { "id" => "team-b-1", "entityId" => "entity-a", "categoryId" => "category-b", "name" => "Time B1" },
        { "id" => "team-b-2", "entityId" => "entity-a", "categoryId" => "category-b", "name" => "Time B2" }
      ],
      "athletes" => [],
      "matches" => [],
      "standingsSnapshot" => [
        { "teamId" => "team-a-1", "played" => 1, "wins" => 1, "draws" => 0, "losses" => 0, "goalsFor" => 4, "goalsAgainst" => 1, "goalDiff" => 3, "points" => 3 },
        { "teamId" => "team-a-2", "played" => 1, "wins" => 0, "draws" => 0, "losses" => 1, "goalsFor" => 1, "goalsAgainst" => 4, "goalDiff" => -3, "points" => 0 },
        { "teamId" => "team-b-1", "played" => 1, "wins" => 1, "draws" => 0, "losses" => 0, "goalsFor" => 2, "goalsAgainst" => 0, "goalDiff" => 2, "points" => 3 },
        { "teamId" => "team-b-2", "played" => 1, "wins" => 0, "draws" => 0, "losses" => 1, "goalsFor" => 0, "goalsAgainst" => 2, "goalDiff" => -2, "points" => 0 }
      ]
    }

    Tempfile.create(["bola-cinco-import", ".json"]) do |file|
      file.write(JSON.pretty_generate(payload))
      file.flush

      championship = BolaCinco::Importer.new(path: file.path).call

      category_a = Category.find_by!(source_id: "category-a")
      category_b = Category.find_by!(source_id: "category-b")

      assert_equal championship, category_a.championship
      assert_equal championship, category_b.championship
      assert_equal [championship.id], category_a.championships.pluck(:id)
      assert_equal [championship.id], category_b.championships.pluck(:id)

      assert_equal [1, 2], StandingRow.where(championship: championship, category: category_a).order(:position).pluck(:position)
      assert_equal [1, 2], StandingRow.where(championship: championship, category: category_b).order(:position).pluck(:position)
    end
  end
end
