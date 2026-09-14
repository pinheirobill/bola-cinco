require "test_helper"
require "tempfile"

class BolaCinco::TrancaSummulaImportTest < ActiveSupport::TestCase
  test "normalizes the jogo label to the numeric code when OCR captures extra text" do
    partida = Struct.new(:dupla_a_nome, :dupla_b_nome).new("Dupla A", "Dupla B")

    Tempfile.create([ "tranca-summula-import", ".txt" ]) do |file|
      text = "Jogo nº: 12- TORNEIO DE EXEMPLO\nMesa nº: 3\nData: 11/9/2026"
      file.write(text)
      file.flush

      importer = BolaCinco::TrancaSummulaImport.new(partida: partida, file: file)
      importer.define_singleton_method(:extract_text) { text }

      header = importer.call[:header]

      assert_equal "12", header[:code]
    end
  end

  test "keeps the trailing jogo number when the label has a prefix" do
    partida = Struct.new(:dupla_a_nome, :dupla_b_nome).new("Dupla A", "Dupla B")

    Tempfile.create([ "tranca-summula-import", ".txt" ]) do |file|
      text = "Jogo nº: 12-1\nMesa nº: 3\nData: 11/9/2026"
      file.write(text)
      file.flush

      importer = BolaCinco::TrancaSummulaImport.new(partida: partida, file: file)
      importer.define_singleton_method(:extract_text) { text }

      header = importer.call[:header]

      assert_equal "1", header[:code]
    end
  end

  test "extracts the partida id from the summary label" do
    partida = Struct.new(:dupla_a_nome, :dupla_b_nome).new("Dupla A", "Dupla B")

    Tempfile.create([ "tranca-summula-import", ".txt" ]) do |file|
      text = "ID do jogo: 197\nJogo nº: 12\nMesa nº: 3\nData: 11/9/2026"
      file.write(text)
      file.flush

      importer = BolaCinco::TrancaSummulaImport.new(partida: partida, file: file)
      importer.define_singleton_method(:extract_text) { text }

      header = importer.call[:header]

      assert_equal 197, header[:partida_id]
    end
  end

  test "does not expose desconto fields in extracted hands" do
    partida = Struct.new(:dupla_a_nome, :dupla_b_nome).new("Dupla A", "Dupla B")

    Tempfile.create([ "tranca-summula-import", ".txt" ]) do |file|
      text = "1ª batida\n10 6\nsem desconto\nsem desconto\n2ª batida\n7 9\nsem desconto\nsem desconto"
      file.write(text)
      file.flush

      importer = BolaCinco::TrancaSummulaImport.new(partida: partida, file: file)
      importer.define_singleton_method(:extract_text) { text }

      hand = importer.call[:hands].first

      assert_equal 1, hand[:numero]
      assert_equal 10, hand[:pontos_a]
      assert_equal 6, hand[:pontos_b]
      assert_not_includes hand.keys, :desconto_a
      assert_not_includes hand.keys, :desconto_b
    end
  end
end
