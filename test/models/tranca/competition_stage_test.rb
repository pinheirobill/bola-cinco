require "test_helper"

class Tranca::CompetitionStageTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-stage",
      name: "Etapas da Tranca",
      season: 2026,
      modality: :tranca
    )
    @category = Category.create!(
      source_id: "cat-tranca-stage",
      championship: @championship,
      name: "Livre"
    )
    @entity = Entity.create!(
      source_id: "entity-tranca-stage",
      name: "Associação Etapas"
    )
    @dupla = Tranca::Dupla.create!(
      source_id: "dupla-tranca-stage",
      championship: @championship,
      category: @category,
      entity: @entity,
      name: "Ana / Maria"
    )
  end

  test "keeps existing competition records in the first stage by default" do
    rodada = create_rodada(source_id: "rodada-stage-default")
    partida = create_partida(source_id: "partida-stage-default")
    classificacao = create_classificacao(source_id: "classificacao-stage-default")

    assert rodada.first_stage?
    assert partida.first_stage?
    assert classificacao.first_stage?
    assert_equal "1ª etapa", rodada.stage_label
  end

  test "allows the same round number in different stages" do
    first_stage = create_rodada(source_id: "rodada-stage-one")
    second_stage = create_rodada(source_id: "rodada-stage-two", stage_number: 2)

    assert_equal [first_stage], @championship.tranca_rodadas.for_stage(1).to_a
    assert_equal [second_stage], @championship.tranca_rodadas.for_stage(2).to_a
    assert second_stage.second_stage?
  end

  test "allows the same dupla position and group in different stages" do
    first_stage = create_classificacao(source_id: "classificacao-stage-one")
    second_stage = create_classificacao(source_id: "classificacao-stage-two", stage_number: 2)

    assert_equal [first_stage], @championship.tranca_classificacao_rows.for_stage(1).to_a
    assert_equal [second_stage], @championship.tranca_classificacao_rows.for_stage(2).to_a
    assert second_stage.second_stage?
  end

  test "filters partidas by stage" do
    first_stage = create_partida(source_id: "partida-stage-one")
    second_stage = create_partida(source_id: "partida-stage-two", stage_number: 2)

    assert_equal [first_stage], @championship.tranca_partidas.for_stage(1).to_a
    assert_equal [second_stage], @championship.tranca_partidas.for_stage(2).to_a
    assert second_stage.second_stage?
  end

  test "rejects invalid stage numbers" do
    rodada = build_rodada(source_id: "rodada-invalid-stage", stage_number: 0)
    partida = build_partida(source_id: "partida-invalid-stage", stage_number: 0)
    classificacao = build_classificacao(source_id: "classificacao-invalid-stage", stage_number: 0)

    assert_not rodada.valid?
    assert_not partida.valid?
    assert_not classificacao.valid?
  end

  private

  def create_rodada(**attributes)
    build_rodada(**attributes).tap(&:save!)
  end

  def build_rodada(source_id:, stage_number: nil)
    attributes = {
      source_id: source_id,
      championship: @championship,
      phase: "classificatoria",
      round_number: 1,
      label: "Rodada 1 · Classificatória"
    }
    attributes[:stage_number] = stage_number if stage_number.present?
    Tranca::Rodada.new(attributes)
  end

  def create_partida(**attributes)
    build_partida(**attributes).tap(&:save!)
  end

  def build_partida(source_id:, stage_number: nil)
    attributes = {
      source_id: source_id,
      championship: @championship,
      category: @category,
      code: source_id.upcase,
      phase: "classificatoria",
      round_number: 1,
      group_key: "A",
      dupla_a: @dupla,
      status: :agendado
    }
    attributes[:stage_number] = stage_number if stage_number.present?
    Tranca::Partida.new(attributes)
  end

  def create_classificacao(**attributes)
    build_classificacao(**attributes).tap(&:save!)
  end

  def build_classificacao(source_id:, stage_number: nil)
    attributes = {
      source_id: source_id,
      championship: @championship,
      category: @category,
      tranca_dupla: @dupla,
      group_key: "A",
      position: 1
    }
    attributes[:stage_number] = stage_number if stage_number.present?
    Tranca::ClassificacaoRow.new(attributes)
  end
end
