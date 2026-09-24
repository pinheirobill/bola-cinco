require "application_system_test_case"
require "securerandom"

class TrancaKnockoutBuilderTest < ApplicationSystemTestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-system-knockout-builder-#{SecureRandom.hex(4)}",
      name: "Torneio de Tranca",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )
    @category = Category.create!(
      source_id: "cat-system-knockout-builder-#{SecureRandom.hex(4)}",
      championship: @championship,
      name: "Livre"
    )
    @entity = Entity.create!(
      source_id: "entity-system-knockout-builder-#{SecureRandom.hex(4)}",
      name: "Clube Tranca"
    )
    @stage1_duplas = %w[A1 A2 A3 A4 B1 B2 B3 B4 C1 C2 C3 C4 D1 D2 D3 D4].index_with do |label|
      Tranca::Dupla.create!(
        source_id: "dupla-system-knockout-builder-#{label.downcase}-#{SecureRandom.hex(4)}",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Etapa 1 #{label}"
      )
    end

    @stage2_duplas = %w[A1 A2 A3 A4 B1 B2 B3 B4 C1 C2 C3 C4 D1 D2 D3 D4].index_with do |label|
      Tranca::Dupla.create!(
        source_id: "dupla-system-knockout-builder-stage2-#{label.downcase}-#{SecureRandom.hex(4)}",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Etapa 2 #{label}"
      )
    end

    seed_knockout_standings(stage_number: 1, duplas: @stage1_duplas)
    seed_knockout_standings(stage_number: 2, duplas: @stage2_duplas)

    login_as users(:one), scope: :user
  end

  teardown do
    @championship&.destroy!
  end

  test "opens the bracket prefilled from the draw" do
    visit rodadas_championship_path(@championship)

    click_button "Configurar chave eliminatória"
    assert_selector "#tranca-knockout-config-modal[open]"

    within "#tranca-knockout-config-modal" do
      assert_text "Etapa 2 A1"
      assert_no_text "Etapa 1 A1"
    end

    click_button "Continuar"

    assert_text "ETAPA 2"
    assert_selector "[data-knockout-builder-target='counter']", text: "16/16 duplas selecionadas"
    assert_selector "[data-slot-id='game-0-0'] [data-slot-name']", text: "Etapa 2 A1"
    assert_selector "[data-slot-id='game-0-1'] [data-slot-name']", text: "Etapa 2 D2"
    assert_text "3º lugar"
    assert_no_text "Arraste uma dupla para cá"
  end

  private

  def seed_knockout_standings(stage_number:, duplas:)
    {
      "A" => [ [ "A1", 100 ], [ "A2", 99 ], [ "A3", 97 ], [ "A4", 96 ] ],
      "B" => [ [ "B1", 90 ], [ "B2", 89 ], [ "B3", 87 ], [ "B4", 86 ] ],
      "C" => [ [ "C1", 80 ], [ "C2", 79 ], [ "C3", 77 ], [ "C4", 76 ] ],
      "D" => [ [ "D1", 70 ], [ "D2", 69 ], [ "D3", 67 ], [ "D4", 66 ] ]
    }.each do |group_key, rows|
      rows.each_with_index do |(label, points), index|
        @championship.tranca_classificacao_rows.create!(
          source_id: "standings-system-knockout-builder-s#{stage_number}-#{group_key.downcase}-#{index + 1}-#{SecureRandom.hex(4)}",
          championship: @championship,
          category: @category,
          tranca_dupla: duplas.fetch(label),
          stage_number: stage_number,
          group_key: group_key,
          position: index + 1,
          points: points,
          goal_diff: 0,
          goals_for: points,
          qualified: index < 2
        )
      end
    end
  end
end
