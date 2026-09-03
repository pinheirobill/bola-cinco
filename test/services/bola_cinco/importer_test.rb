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

    Tempfile.create([ "bola-cinco-import", ".json" ]) do |file|
      file.write(JSON.pretty_generate(payload))
      file.flush

      championship = BolaCinco::Importer.new(path: file.path).call

      category_a = Category.find_by!(source_id: "category-a")
      category_b = Category.find_by!(source_id: "category-b")

      assert_equal championship, category_a.championship
      assert_equal championship, category_b.championship
      assert_equal [ championship.id ], category_a.championships.pluck(:id)
      assert_equal [ championship.id ], category_b.championships.pluck(:id)

      assert_equal [ 1, 2 ], StandingRow.where(championship: championship, category: category_a).order(:position).pluck(:position)
      assert_equal [ 1, 2 ], StandingRow.where(championship: championship, category: category_b).order(:position).pluck(:position)
    end
  end

  test "can import the same standings snapshot more than once" do
    payload = {
      "championship" => {
        "id" => "championship-import-replay",
        "name" => "Campeonato Repetido",
        "season" => 2026,
        "status" => "em_andamento"
      },
      "categories" => [
        { "id" => "category-replay", "name" => "Sub 11" }
      ],
      "entities" => [
        { "id" => "entity-replay", "name" => "Entidade Repetida" }
      ],
      "teams" => [
        { "id" => "team-replay-1", "entityId" => "entity-replay", "categoryId" => "category-replay", "name" => "Time Repetido 1" },
        { "id" => "team-replay-2", "entityId" => "entity-replay", "categoryId" => "category-replay", "name" => "Time Repetido 2" }
      ],
      "athletes" => [],
      "matches" => [],
      "standingsSnapshot" => [
        { "teamId" => "team-replay-1", "position" => 1, "played" => 1, "wins" => 1, "draws" => 0, "losses" => 0, "goalsFor" => 2, "goalsAgainst" => 0, "goalDiff" => 2, "points" => 3 },
        { "teamId" => "team-replay-2", "position" => 2, "played" => 1, "wins" => 0, "draws" => 0, "losses" => 1, "goalsFor" => 0, "goalsAgainst" => 2, "goalDiff" => -2, "points" => 0 }
      ]
    }

    Tempfile.create([ "bola-cinco-import-replay", ".json" ]) do |file|
      file.write(JSON.pretty_generate(payload))
      file.flush

      importer = BolaCinco::Importer.new(path: file.path)
      championship = importer.call

      assert_nothing_raised { importer.call }
      assert_equal 2, StandingRow.where(championship: championship).count
      assert_equal [ 1, 2 ], StandingRow.where(championship: championship).order(:position).pluck(:position)
    end
  end

  test "does not mirror tranca matches without a round" do
    payload = {
      "championship" => {
        "id" => "championship-tranca-without-round",
        "name" => "Tranca sem rodada",
        "season" => 2026,
        "status" => "em_andamento",
        "modality" => "tranca"
      },
      "categories" => [
        { "id" => "category-tranca-without-round", "name" => "Duplas" }
      ],
      "entities" => [
        { "id" => "entity-tranca-without-round", "name" => "Entidade" }
      ],
      "teams" => [
        {
          "id" => "team-tranca-without-round",
          "entityId" => "entity-tranca-without-round",
          "categoryId" => "category-tranca-without-round",
          "name" => "Dupla"
        }
      ],
      "athletes" => [],
      "matches" => [
        {
          "id" => "match-tranca-without-round",
          "categoryId" => "category-tranca-without-round",
          "code" => "JG001",
          "phase" => "classificatoria",
          "round" => nil,
          "status" => "agendado"
        }
      ],
      "standingsSnapshot" => []
    }

    Tempfile.create([ "bola-cinco-tranca-without-round", ".json" ]) do |file|
      file.write(JSON.pretty_generate(payload))
      file.flush

      assert_nothing_raised { BolaCinco::Importer.new(path: file.path).call }
      assert_equal 0, Tranca::Partida.count
    end
  end
end
