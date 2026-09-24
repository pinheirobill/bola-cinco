require "test_helper"
require "securerandom"

class Tranca::SecondStageKnockoutBuilderTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-tranca-second-stage-knockout-#{SecureRandom.hex(4)}",
      name: "Mata-mata da 2ª etapa",
      season: 2026,
      modality: :tranca
    )
    @category = Category.create!(
      source_id: "cat-tranca-second-stage-knockout-#{SecureRandom.hex(4)}",
      championship: @championship,
      name: "Livre"
    )
    @entity = Entity.create!(
      source_id: "entity-tranca-second-stage-knockout-#{SecureRandom.hex(4)}",
      name: "Clube"
    )

    @duplas = %w[A1 A2 B1 B2 C1 C2 D1 D2].index_with do |label|
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-second-stage-knockout-#{label.downcase}-#{SecureRandom.hex(4)}",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Dupla #{label}"
      )
    end

    {
      "A" => [ "A1", "A2" ],
      "B" => [ "B1", "B2" ],
      "C" => [ "C1", "C2" ],
      "D" => [ "D1", "D2" ]
    }.each do |group_key, labels|
      labels.each_with_index do |label, index|
        @championship.tranca_classificacao_rows.create!(
          source_id: "standing-tranca-second-stage-knockout-#{group_key.downcase}-#{index + 1}-#{SecureRandom.hex(4)}",
          championship: @championship,
          category: @category,
          tranca_dupla: @duplas.fetch(label),
          stage_number: 2,
          group_key: group_key,
          position: index + 1
        )
      end
    end
  end

  test "creates quarterfinals in the official spreadsheet order" do
    builder = Tranca::SecondStageKnockoutBuilder.new(@championship)

    builder.stub(:second_stage_complete?, true) do
      round = builder.create!
      assert_equal 1, round.round_number
    end

    matches = @championship.tranca_partidas.where(stage_number: 2, phase: "mata_mata").order(:code)
    assert_equal [
      [ @duplas.fetch("A1").id, @duplas.fetch("D2").id ],
      [ @duplas.fetch("B1").id, @duplas.fetch("C2").id ],
      [ @duplas.fetch("C1").id, @duplas.fetch("B2").id ],
      [ @duplas.fetch("D1").id, @duplas.fetch("A2").id ]
    ], matches.pluck(:dupla_a_id, :dupla_b_id)
    assert_equal %w[E2-QF1 E2-QF2 E2-QF3 E2-QF4], matches.pluck(:code)
  end
end
