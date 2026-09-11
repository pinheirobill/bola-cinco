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
end
