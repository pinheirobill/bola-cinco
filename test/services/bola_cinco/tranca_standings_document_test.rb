require "test_helper"

class BolaCinco::TrancaStandingsDocumentTest < ActiveSupport::TestCase
  Category = Struct.new(:name)
  Group = Struct.new(:category, :group_key, :rows)
  Team = Struct.new(:name)
  Row = Struct.new(:tranca_dupla, :played, :wins, :goals_for, :goals_against, :goal_diff, :points)

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
        Row.new(Team.new("Dupla A"), 3, 2, 156, 124, 32, 6)
      ]
    )
    dupla = Struct.new(:name, :integrante_names, :category).new("Dupla A", [ "Fulano", "Beltrano" ], Category.new("Chave 1"))

    document = CaptureDocument.new(championship, groups: [ group ], duplas: [ dupla ])

    assert_nothing_raised do
      document.render
    end

    classification_table = document.captured_tables.first
    assert_equal [ "#", "Dupla", "J", "V", "PTS PRÓ", "PTS CONTRA", "SALDO", "PTS" ], classification_table[1]
    assert_equal 8, classification_table[2].size
    assert_equal [ 1, "Dupla A", 3, 2, 156, 124, 32, 6 ], classification_table[3].first
  end
end
