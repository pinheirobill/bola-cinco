require "test_helper"
require "zip"
require "tempfile"
require "cgi"

class Tranca::RoundGamesSpreadsheetTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-spreadsheet",
      name: "Torneio de Tranca",
      season: 2026,
      modality: :tranca
    )

    @category = Category.create!(
      source_id: "cat-tranca-spreadsheet",
      championship: @championship,
      name: "Livre"
    )

    @entity = Entity.create!(source_id: "entity-tranca-spreadsheet", name: "Entidade")

    @dupla_a = Tranca::Dupla.create!(
      source_id: "dupla-tranca-a",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Zeta / Par"
    )
    @dupla_b = Tranca::Dupla.create!(
      source_id: "dupla-tranca-b",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Alpha / Par"
    )
    @dupla_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Beta / Par"
    )
    @dupla_d = Tranca::Dupla.create!(
      source_id: "dupla-tranca-d",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Gamma / Par"
    )

    @round = Tranca::Rodada.create!(
      source_id: "round-tranca-spreadsheet",
      championship: @championship,
      phase: "classificatoria",
      round_number: 1,
      label: "Rodada 1"
    )

    @mesa_1 = Tranca::Mesa.create!(
      source_id: "mesa-tranca-1",
      championship: @championship,
      tranca_rodada: @round,
      code: "1",
      name: "Mesa 1"
    )
    @mesa_2 = Tranca::Mesa.create!(
      source_id: "mesa-tranca-2",
      championship: @championship,
      tranca_rodada: @round,
      code: "2",
      name: "Mesa 2"
    )

    @match_a = Tranca::Partida.create!(
      source_id: "partida-tranca-a",
      championship: @championship,
      category: @category,
      tranca_rodada: @round,
      tranca_mesa: @mesa_2,
      dupla_a: @dupla_a,
      dupla_b: @dupla_b,
      code: "JG 20",
      phase: "classificatoria",
      round_number: 1,
      group_key: "Chave B"
    )

    @match_b = Tranca::Partida.create!(
      source_id: "partida-tranca-b",
      championship: @championship,
      category: @category,
      tranca_rodada: @round,
      tranca_mesa: @mesa_1,
      dupla_a: @dupla_c,
      dupla_b: @dupla_d,
      code: "JG 10",
      phase: "classificatoria",
      round_number: 1,
      group_key: "Chave A"
    )
  end

  test "renders the presence layout ordered by mesa" do
    xml = sheet_xml(Tranca::RoundGamesSpreadsheet.new(@round, [ @match_a, @match_b ], order: :mesa).render)
    values = sheet_values(xml)

    assert_equal "Torneio de Tranca", values.first
    assert_includes xml, "<mergeCell ref=\"A1:D1\"/>"
    assert_equal [ "CHAVE", "MESA", "JOGO", "DUPLA 01" ], values.slice(1, 4)
    assert_equal [ "A", "1", "10", "Beta / Par", "A", "1", "10", "Gamma / Par", "B", "2", "20", "Zeta / Par", "B", "2", "20", "Alpha / Par" ],
      values.drop(5)
  end

  test "renders the presence layout ordered by participant name" do
    xml = sheet_xml(Tranca::RoundGamesSpreadsheet.new(@round, [ @match_a, @match_b ], order: :name).render)
    values = sheet_values(xml)

    assert_equal [ "Alpha / Par", "Beta / Par", "Gamma / Par", "Zeta / Par" ], values.drop(5).each_slice(4).map(&:last)
  end

  private

  def sheet_xml(blob)
    Tempfile.create(["round-games", ".xlsx"]) do |file|
      file.binmode
      file.write(blob)
      file.flush
      Zip::File.open(file.path) { |zip| zip.read("xl/worksheets/sheet1.xml") }
    end
  end

  def sheet_values(xml)
    xml.scan(%r{<t[^>]*>([^<]*)</t>|<v>([^<]*)</v>}m).flatten.compact.map { |value| CGI.unescapeHTML(value) }
  end
end
