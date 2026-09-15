require "test_helper"

class TrancaPublicHomeTest < ActionDispatch::IntegrationTest
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-public-home",
      name: "TORNEIO PÚBLICO DE TRANCA",
      season: 2099,
      modality: :tranca,
      status: :em_andamento
    )

    category = Category.create!(
      source_id: "cat-tranca-public-home",
      championship: @championship,
      name: "Livre"
    )

    entity = Entity.create!(
      source_id: "entity-tranca-public-home",
      name: "Dupla Líder"
    )

    dupla = Tranca::Dupla.create!(
      source_id: "dupla-tranca-public-home",
      championship: @championship,
      category: category,
      entity: entity,
      name: "Ana / Carlos"
    )

    Tranca::ClassificacaoRow.create!(
      source_id: "ranking-tranca-public-home",
      championship: @championship,
      category: category,
      tranca_dupla: dupla,
      position: 1,
      played: 3,
      wins: 3,
      goals_for: 9,
      goals_against: 2,
      goal_diff: 7,
      points: 9
    )
  end

  test "shows a focused public portal with the complete classification" do
    get tranca_root_path

    assert_response :success
    assert_select "h1", text: "TORNEIO PÚBLICO DE TRANCA"
    assert_select "#classificacao", text: /Classificação geral/
    assert_select "#classificacao", text: /Ana \/ Carlos/
    assert_select "a", text: "Entrar", count: 0
    assert_select "a", text: "Admin", count: 0
    assert_select "h2", text: "Ao vivo", count: 0
    assert_select "h2", text: "Duplas", count: 0
    assert_select "h2", text: "Mais", count: 0
  end
end
