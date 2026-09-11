require "test_helper"
require "open3"
require "tempfile"

class TrancaProgramacaoTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)

    @championship = Championship.create!(
      source_id: "champ-tranca-programacao",
      name: "Programação Tranca",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )
    @championship.logo.attach(fixture_file_upload("championship-logo.png", "image/png"))

    @category = Category.create!(
      source_id: "cat-tranca-programacao",
      championship: @championship,
      name: "Livre"
    )

    @entity = Entity.create!(
      source_id: "entity-tranca-programacao",
      name: "Entidade"
    )

    @dupla_a = Tranca::Dupla.create!(
      source_id: "dupla-tranca-programacao-a",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Rosa / Claudia"
    )

    @dupla_b = Tranca::Dupla.create!(
      source_id: "dupla-tranca-programacao-b",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Mario / Renata"
    )

    @round = Tranca::Rodada.create!(
      source_id: "round-tranca-programacao",
      championship: @championship,
      phase: "classificatoria",
      round_number: 1,
      label: "Rodada 1"
    )

    @mesa = Tranca::Mesa.create!(
      source_id: "mesa-tranca-programacao",
      championship: @championship,
      tranca_rodada: @round,
      code: "1",
      name: "Mesa 1"
    )

    Tranca::Partida.create!(
      source_id: "partida-tranca-programacao-1",
      championship: @championship,
      category: @category,
      tranca_rodada: @round,
      tranca_mesa: @mesa,
      dupla_a: @dupla_a,
      dupla_b: @dupla_b,
      code: "JG 1",
      phase: "classificatoria",
      round_number: 1,
      group_key: "Chave A",
      scheduled_on: Date.new(2026, 9, 19),
      scheduled_time: "17:13"
    )

    Tranca::Partida.create!(
      source_id: "partida-tranca-programacao-2",
      championship: @championship,
      category: @category,
      tranca_rodada: @round,
      tranca_mesa: @mesa,
      dupla_a: @dupla_b,
      dupla_b: @dupla_a,
      code: "JG 2",
      phase: "classificatoria",
      round_number: 1,
      group_key: "Chave B",
      scheduled_on: Date.new(2026, 9, 19),
      scheduled_time: "17:13"
    )
  end

  test "shows the programacao screen with the PDF layout" do
    get programacao_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Programação de jogos"
    assert_includes response.body, "Logo do campeonato"
    assert_includes response.body, "CHAVE A"
    assert_includes response.body, "CHAVE B"
    assert_includes response.body, "JG 1"
    assert_includes response.body, "JG 2"
    assert_includes response.body, "Rosa / Claudia"
    assert_includes response.body, "Mario / Renata"
  end

  test "exports the programacao pdf with the same layout text" do
    get programacao_championship_path(@championship, format: :pdf)

    assert_response :success
    assert_equal "application/pdf", response.media_type

    Tempfile.create([ "programacao", ".pdf" ]) do |file|
      file.binmode
      file.write(response.body)
      file.flush
      stdout, stderr, status = Open3.capture3("pdftotext", file.path, "-")
      assert status.success?, stderr

      extracted = stdout
      assert_includes extracted, "Programação Tranca"
      assert_includes extracted, "CHAVE A"
      assert_includes extracted, "CHAVE B"
      assert_includes extracted, "JG 1"
      assert_includes extracted, "JG 2"
      assert_includes extracted, "Rosa / Claudia"
      assert_includes extracted, "Mario / Renata"
    end
  end
end
