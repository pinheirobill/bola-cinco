require "test_helper"

class Tranca::DashboardTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-dashboard",
      name: "Dashboard Tranca",
      season: 2026,
      modality: :tranca
    )

    @category = Category.create!(
      source_id: "cat-tranca-dashboard",
      championship: @championship,
      name: "Livre"
    )

    @entity = Entity.create!(
      source_id: "entity-tranca-dashboard",
      name: "Associação Tranca"
    )

    @dupla_a = Tranca::Dupla.create!(
      source_id: "tranca-dupla-a-dashboard",
      championship: @championship,
      entity: @entity,
      category: @category,
      name: "Carlos / Ana"
    )

    @dupla_b = Tranca::Dupla.create!(
      source_id: "tranca-dupla-b-dashboard",
      championship: @championship,
      entity: @entity,
      category: @category,
      name: "Pedro / Maria"
    )

    @rodada = Tranca::Rodada.create!(
      championship: @championship,
      source_id: "tranca-rodada-dashboard",
      phase: "classificatoria",
      round_number: 2,
      label: "Rodada 2 · Classificatória",
      status: "em_andamento"
    )

    @mesa = Tranca::Mesa.create!(
      championship: @championship,
      tranca_rodada: @rodada,
      source_id: "tranca-mesa-dashboard",
      code: "T1",
      name: "Mesa T1",
      status: "em_uso"
    )

    @partida = Tranca::Partida.create!(
      source_id: "tranca-partida-dashboard",
      championship: @championship,
      category: @category,
      code: "T1",
      phase: "classificatoria",
      round_number: 2,
      status: :em_andamento,
      tranca_rodada: @rodada,
      tranca_mesa: @mesa,
      dupla_a: @dupla_a,
      dupla_b: @dupla_b
    )

    Tranca::ClassificacaoRow.create!(
      source_id: "tranca-standing-row-dashboard",
      championship: @championship,
      category: @category,
      tranca_dupla: @dupla_a,
      position: 1,
      played: 1,
      wins: 1,
      draws: 0,
      losses: 0,
      goals_for: 4,
      goals_against: 2,
      goal_diff: 2,
      points: 3
    )
  end

  test "wraps the championship data in tranca domain objects" do
    dashboard = Tranca::Dashboard.new(@championship)

    assert_equal 2, dashboard.total_duplas
    assert_equal 1, dashboard.total_partidas
    assert_equal 1, dashboard.total_rodadas
    assert_equal 1, dashboard.total_classificados
    assert_equal "Carlos / Ana", dashboard.duplas.first.name
    assert_equal "Mesa T1", dashboard.partidas.first.mesa
    assert_equal "Rodada 2 · Classificatória", dashboard.rodadas.first.label
    assert_equal "Carlos / Ana", dashboard.classificacao_rows.first.dupla
  end
end
