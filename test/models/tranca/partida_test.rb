require "test_helper"

class Tranca::PartidaTest < ActiveSupport::TestCase
  test "returns only the numeric part of the code when present" do
    partida = Tranca::Partida.new(code: "12- TORNEIO DE EXEMPLO")

    assert_equal "12", partida.game_number_label
  end

  test "falls back to the original code when no number exists" do
    partida = Tranca::Partida.new(code: "Final")

    assert_equal "Final", partida.game_number_label
  end
end
