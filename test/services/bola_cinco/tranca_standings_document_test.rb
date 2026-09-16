require "test_helper"

class BolaCinco::TrancaStandingsDocumentTest < ActiveSupport::TestCase
  Category = Struct.new(:name)
  Group = Struct.new(:category, :group_key, :rows)
  Team = Struct.new(:name, :integrante_names, :category)
  Row = Struct.new(:tranca_dupla, :played, :wins, :goals_for, :goals_against, :goal_diff, :points, :position, :category, :group_key)

  class CaptureDocument < BolaCinco::TrancaStandingsDocument
    attr_reader :captured_tables

    private

    def draw_table(title, headers, widths, rows)
      @captured_tables ||= []
      @captured_tables << [ title, headers, widths, rows ]
    end
  end

  test "renders tranca standings with points for and against columns" do
    championship = Struct.new(:name, :logo).new("12o Torneio", nil)
    group = Group.new(
      Category.new("12o Torneio"),
      "Chave 1",
      [
        Row.new(Team.new("Dupla A", [ "Fulano", "Beltrano" ], Category.new("Chave 1")), 3, 2, 156, 124, 32, 6, 1),
        Row.new(Team.new("Dupla B", [ "Alice", "Bob" ], Category.new("Chave 1")), 3, 3, 180, 120, 60, 9, 2)
      ]
    )
    document = CaptureDocument.new(championship, groups: [ group ])

    assert_nothing_raised do
      document.render
    end

    classification_table = document.captured_tables.first
    assert_equal [ "#", "Dupla", "J", "V", "PTS PRÓ", "PTS CONTRA", "SALDO", "PTS" ], classification_table[1]
    assert_equal 8, classification_table[2].size
    assert_equal [ 1, "Dupla A", 3, 2, 156, 124, 32, 6 ], classification_table[3].first
    assert_equal [ 2, "Dupla B", 3, 3, 180, 120, 60, 9 ], classification_table[3].second

    assert_equal "12o Torneio · Chave A", classification_table[0]

    ranking_table = document.captured_tables.second
    assert_equal "Melhores duplas", ranking_table[0]
    assert_equal [ "#", "", "Dupla", "Vitórias", "Pontos", "Saldo" ], ranking_table[1]
    assert_equal 6, ranking_table[2].size
    assert_equal [ 1, nil, "Dupla B", 3, 180, 60 ], ranking_table[3].first
    assert_equal [ 2, true, "Dupla A", 2, 156, 32 ], ranking_table[3].second
  end

  test "orders general ranking by wins points scored and score difference" do
    championship = Struct.new(:name, :logo).new("12o Torneio", nil)
    category = Category.new("12o Torneio")
    rows = [
      Row.new(Team.new("Dupla C", [], category), 3, 2, 200, 100, 100, 2, 1),
      Row.new(Team.new("Dupla A", [], category), 3, 3, 180, 120, 60, 3, 1),
      Row.new(Team.new("Dupla B", [], category), 3, 3, 180, 100, 80, 3, 2)
    ]
    groups = [ Group.new(category, "Chave 1", rows) ]
    document = BolaCinco::TrancaStandingsDocument.new(championship, groups: groups)

    assert_equal [
      [ 1, nil, "Dupla B", 3, 180, 80 ],
      [ 2, true, "Dupla A", 3, 180, 60 ],
      [ 3, true, "Dupla C", 2, 200, 100 ]
    ], document.send(:general_ranking_rows)
  end

  test "formats numeric tranca keys as alphabetic labels" do
    championship = Struct.new(:name, :logo).new("12o Torneio", nil)
    category = Category.new("12o Torneio")
    document = BolaCinco::TrancaStandingsDocument.new(championship, groups: [])

    assert_equal "12o Torneio · Chave A", document.send(:classification_group_title, Group.new(category, "Chave 1", []))
    assert_equal "12o Torneio · Chave B", document.send(:classification_group_title, Group.new(category, "Chave 2", []))
    assert_equal "12o Torneio · Chave C", document.send(:classification_group_title, Group.new(category, "Chave 3", []))
  end

  test "highlights only the first place of each classification group in green" do
    championship = Struct.new(:name, :logo).new("12o Torneio", nil)
    document = BolaCinco::TrancaStandingsDocument.new(championship, groups: [])
    document.instance_variable_set(:@section, "Classificação")

    assert_equal BolaCinco::TrancaStandingsDocument::FIRST_PLACE, document.send(:standings_row_fill, 0)
    assert_equal BolaCinco::TrancaStandingsDocument::ROW_ALT, document.send(:standings_row_fill, 1)

    document.instance_variable_set(:@section, "Participantes")

    assert_equal "FFFFFF", document.send(:standings_row_fill, 0)
  end
end
