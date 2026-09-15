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
      Category.new("Chave 1"),
      "Grupo A",
      [
        Row.new(Team.new("Dupla A", [ "Fulano", "Beltrano" ], Category.new("Chave 1")), 3, 2, 156, 124, 32, 6, 1),
        Row.new(Team.new("Dupla B", [ "Alice", "Bob" ], Category.new("Chave 1")), 3, 3, 180, 120, 60, 9, 2)
      ]
    )
    dupla_a = Team.new("Dupla A", [ "Fulano", "Beltrano" ], Category.new("Chave 1"))
    dupla_b = Team.new("Dupla B", [ "Alice", "Bob" ], Category.new("Chave 1"))

    document = CaptureDocument.new(championship, groups: [ group ], duplas: [ dupla_a, dupla_b ])

    assert_nothing_raised do
      document.render
    end

    classification_table = document.captured_tables.first
    assert_equal [ "#", "Dupla", "J", "V", "PTS PRÓ", "PTS CONTRA", "SALDO", "PTS" ], classification_table[1]
    assert_equal 8, classification_table[2].size
    assert_equal [ 1, "Dupla A", 3, 2, 156, 124, 32, 6 ], classification_table[3].first
    assert_equal [ 2, "Dupla B", 3, 3, 180, 120, 60, 9 ], classification_table[3].second

    participants_table = document.captured_tables.second
    assert_equal [ "#", "Dupla", "Participantes", "PTS" ], participants_table[1]
    assert_equal 4, participants_table[2].size
    assert_equal [ 1, "Dupla B", "Alice\nBob", 9 ], participants_table[3].first
    assert_equal [ 2, "Dupla A", "Fulano\nBeltrano", 6 ], participants_table[3].second
  end

  test "highlights only the first place of each classification group in green" do
    championship = Struct.new(:name, :logo).new("12o Torneio", nil)
    document = BolaCinco::TrancaStandingsDocument.new(championship, groups: [], duplas: [])
    document.instance_variable_set(:@section, "Classificação")

    assert_equal BolaCinco::TrancaStandingsDocument::FIRST_PLACE, document.send(:standings_row_fill, 0)
    assert_equal BolaCinco::TrancaStandingsDocument::ROW_ALT, document.send(:standings_row_fill, 1)

    document.instance_variable_set(:@section, "Participantes")

    assert_equal "FFFFFF", document.send(:standings_row_fill, 0)
  end
end
