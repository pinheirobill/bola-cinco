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
      group_key: "Chave 1",
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
      group_key: "Chave 2",
      scheduled_on: Date.new(2026, 9, 19),
      scheduled_time: "17:13"
    )

    @dupla_c = Tranca::Dupla.create!(
      source_id: "dupla-tranca-programacao-c",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Azul / Verde"
    )

    @dupla_d = Tranca::Dupla.create!(
      source_id: "dupla-tranca-programacao-d",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Preto / Branco"
    )

    @second_stage_round = Tranca::Rodada.create!(
      source_id: "round-tranca-programacao-stage-2",
      championship: @championship,
      stage_number: 2,
      phase: "mata_mata",
      round_number: 1,
      label: "2ª etapa · Quartas de final"
    )

    Tranca::Partida.create!(
      source_id: "partida-tranca-programacao-3",
      championship: @championship,
      category: @category,
      tranca_rodada: @second_stage_round,
      dupla_a: @dupla_c,
      dupla_b: @dupla_d,
      code: "E2 JG 1",
      phase: "mata_mata",
      stage_number: 2,
      round_number: 1,
      group_key: "Chave A",
      scheduled_on: Date.new(2026, 9, 20),
      scheduled_time: "20:00"
    )
  end

  test "shows the programacao screen with the PDF layout" do
    get programacao_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Programação de jogos"
    assert_includes response.body, "Telão"
    assert_includes response.body, "Etapa 1"
    assert_includes response.body, "Etapa 2"
    assert_includes response.body, "JG 1"
    assert_includes response.body, "JG 2"
    assert_includes response.body, "JG 3"
    assert_includes response.body, "Rosa / Claudia"
    assert_includes response.body, "Mario / Renata"
    assert_includes response.body, "Azul / Verde"
    assert_includes response.body, "Preto / Branco"
    assert_includes response.body, "stage=all"
    assert_not_includes response.body, "Excluir chave"
  end

  test "shows the selected stage in the programacao screen and keeps it on exports" do
    get programacao_championship_path(@championship, stage: 2)

    assert_response :success
    assert_includes response.body, "Selecionado: Etapa 2"
    assert_includes response.body, "stage=2"
    assert_includes response.body, "Etapa 2"
    assert_includes response.body, "Azul / Verde"
    assert_includes response.body, "Preto / Branco"
    assert_not_includes response.body, "Rosa / Claudia"
    assert_not_includes response.body, "Mario / Renata"

    get programacao_championship_path(@championship, format: :pdf, stage: 2)

    assert_response :success
    assert_equal "application/pdf", response.media_type
    extracted = extract_pdf_text(response.body)
    assert_includes extracted, "Azul / Verde"
    assert_includes extracted, "Preto / Branco"
    assert_not_includes extracted, "Rosa / Claudia"
    assert_not_includes extracted, "Mario / Renata"
  end

  test "shows the programacao telao screen" do
    get programacao_telao_championship_path(@championship)

    assert_response :success
    assert_includes response.body, "Rosa / Claudia"
    assert_includes response.body, "Mario / Renata"
    assert_includes response.body, "Azul / Verde"
    assert_includes response.body, "Preto / Branco"
    assert_includes response.body, "JG 1"
    assert_includes response.body, "JG 2"
    assert_includes response.body, "JG 3"
    assert_includes response.body, "Tempo em minutos"
    assert_includes response.body, "data-programacao-duration"
    assert_includes response.body, "data-programacao-zoom"
    assert_includes response.body, "data-programacao-zoom-label"
    assert_includes response.body, "formatRemaining"
    assert_not_includes response.body, "Excluir chave"
    assert_no_match(/navbar|sidebar/i, response.body)

    document = Nokogiri::HTML(response.body)
    assert_equal 2, document.css("[data-programacao-timer]").size
    assert_equal 2, document.css("[data-programacao-duration]").size
    assert_equal "45", document.at_css("[data-programacao-duration]")["value"]
  end

  test "shows only the selected stage on the programacao telao screen" do
    get programacao_telao_championship_path(@championship, stage: 2)

    assert_response :success
    assert_includes response.body, "Etapa 2"
    assert_includes response.body, "Azul / Verde"
    assert_includes response.body, "Preto / Branco"
    assert_not_includes response.body, "Rosa / Claudia"
    assert_not_includes response.body, "Mario / Renata"
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
    assert_includes extracted, "Rosa / Claudia"
    assert_includes extracted, "Mario / Renata"
    assert_includes extracted, "Azul / Verde"
    assert_includes extracted, "Preto / Branco"
    assert_includes extracted, "JG 1"
    assert_includes extracted, "JG 2"

      stdout, stderr, status = Open3.capture3("pdfinfo", file.path)
      assert status.success?, stderr
      assert_match(/Page size:\s+1600 x 720 pts/, stdout)
    end
  end

  private

  def extract_pdf_text(pdf_data)
    Tempfile.create([ "programacao", ".pdf" ]) do |file|
      file.binmode
      file.write(pdf_data)
      file.flush
      stdout, stderr, status = Open3.capture3("pdftotext", "-layout", file.path, "-")
      assert status.success?, stderr
      stdout
    end
  end
end
