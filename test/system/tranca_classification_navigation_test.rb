require "application_system_test_case"
require "securerandom"

class TrancaClassificationNavigationTest < ApplicationSystemTestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-system-classification-navigation-#{SecureRandom.hex(4)}",
      name: "Torneio de Tranca",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )

    @category = Category.create!(
      source_id: "cat-system-classification-navigation-#{SecureRandom.hex(4)}",
      championship: @championship,
      name: "Livre"
    )

    @entity = Entity.create!(
      source_id: "entity-system-classification-navigation-#{SecureRandom.hex(4)}",
      name: "Clube Tranca"
    )

    @duplas = 8.times.index_with do |index|
      Tranca::Dupla.create!(
        source_id: "dupla-system-classification-navigation-#{index + 1}-#{SecureRandom.hex(4)}",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Dupla #{index + 1}"
      )
    end

    seed_stage_rows(stage_number: 1, group_key: "A", duplas: @duplas.values.slice(0, 2))
    seed_stage_rows(stage_number: 1, group_key: "B", duplas: @duplas.values.slice(2, 2))
    seed_stage_rows(stage_number: 2, group_key: "C", duplas: @duplas.values.slice(4, 2))
    seed_stage_rows(stage_number: 2, group_key: "D", duplas: @duplas.values.slice(6, 2))

    login_as users(:one), scope: :user
  end

  teardown do
    @championship&.destroy!
  end

  test "shows all groups for the selected stage" do
    visit classificacao_championship_path(@championship)

    assert_text "Chave A"
    assert_text "Chave B"
    assert_no_text "Chave C"
    assert_no_text "Chave D"

    click_button "Etapa 2"

    assert_no_text "Chave A"
    assert_no_text "Chave B"
    assert_text "Chave C"
    assert_text "Chave D"
  end

  private

  def seed_stage_rows(stage_number:, group_key:, duplas:)
    duplas.each_with_index do |dupla, index|
      @championship.tranca_classificacao_rows.create!(
        source_id: "standing-navigation-s#{stage_number}-#{group_key}-#{index + 1}-#{SecureRandom.hex(4)}",
        championship: @championship,
        category: @category,
        tranca_dupla: dupla,
        stage_number: stage_number,
        group_key: group_key,
        position: index + 1,
        points: 3 - index,
        goal_diff: 0,
        goals_for: 0,
        qualified: index.zero?
      )
    end
  end
end
