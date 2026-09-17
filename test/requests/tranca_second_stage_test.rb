require "test_helper"

class TrancaSecondStageTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)

    @championship = Championship.create!(
      source_id: "champ-tranca-second-stage-request",
      name: "2ª Etapa Web",
      season: 2026,
      modality: :tranca,
      status: :em_andamento
    )
    @category = Category.create!(
      source_id: "cat-tranca-second-stage-request",
      championship: @championship,
      name: "Livre"
    )
    @entity = Entity.create!(
      source_id: "entity-tranca-second-stage-request",
      name: "Associação Segunda Etapa Web"
    )
    @duplas = 16.times.map do |index|
      Tranca::Dupla.create!(
        source_id: "dupla-tranca-second-stage-request-#{index + 1}",
        championship: @championship,
        category: @category,
        entity: @entity,
        name: "Dupla Web #{index + 1}"
      )
    end
    @groups = %w[A B C D].each_with_index.to_h do |group_key, group_index|
      [group_key, @duplas.slice(group_index * 4, 4).map(&:id)]
    end
  end

  test "shows the modal with sixteen manual positions" do
    prefill_distribution = {
      "A" => [["A", 1], ["I", 1], ["E", 1], ["D", 2]],
      "B" => [["B", 1], ["E", 2], ["F", 1], ["H", 2]],
      "C" => [["C", 1], ["A", 2], ["G", 1], ["F", 2]],
      "D" => [["D", 1], ["G", 2], ["H", 1], ["C", 2]]
    }

    prefill_distribution.each_with_index do |(group_key, source_positions), group_index|
      source_positions.each_with_index do |(source_group_key, position), row_index|
        dupla = @duplas.fetch(group_index * 4 + row_index)
        @championship.tranca_classificacao_rows.create!(
          source_id: "tranca-second-stage-prefill-#{group_key}-#{row_index + 1}",
          championship: @championship,
          category: @category,
          tranca_dupla: dupla,
          stage_number: 1,
          group_key: source_group_key,
          position: position
        )
      end
    end

    get rodadas_championship_path(@championship)

    assert_response :success
    assert_select "#tranca-second-stage-modal"
    assert_select "select[data-second-stage-builder-target='select']", count: 16
    assert_select "select[name='groups[A][]']", count: 4
    assert_select "select[name='groups[D][]']", count: 4
    assert_select "select[name='groups[A][]'] option[selected='selected'][value='#{@duplas[0].id}']"
    assert_select "select[name='groups[A][]'] option[selected='selected'][value='#{@duplas[1].id}']"
    assert_select "select[name='groups[A][]'] option[selected='selected'][value='#{@duplas[2].id}']"
    assert_select "select[name='groups[A][]'] option[selected='selected'][value='#{@duplas[3].id}']"
    assert_select "select[name='groups[B][]'] option[selected='selected'][value='#{@duplas[4].id}']"
    assert_select "select[name='groups[B][]'] option[selected='selected'][value='#{@duplas[5].id}']"
    assert_select "select[name='groups[B][]'] option[selected='selected'][value='#{@duplas[6].id}']"
    assert_select "select[name='groups[B][]'] option[selected='selected'][value='#{@duplas[7].id}']"
    assert_select "select[name='groups[C][]'] option[selected='selected'][value='#{@duplas[8].id}']"
    assert_select "select[name='groups[C][]'] option[selected='selected'][value='#{@duplas[9].id}']"
    assert_select "select[name='groups[C][]'] option[selected='selected'][value='#{@duplas[10].id}']"
    assert_select "select[name='groups[C][]'] option[selected='selected'][value='#{@duplas[11].id}']"
    assert_select "select[name='groups[D][]'] option[selected='selected'][value='#{@duplas[12].id}']"
    assert_select "select[name='groups[D][]'] option[selected='selected'][value='#{@duplas[13].id}']"
    assert_select "select[name='groups[D][]'] option[selected='selected'][value='#{@duplas[14].id}']"
    assert_select "select[name='groups[D][]'] option[selected='selected'][value='#{@duplas[15].id}']"
    assert_includes response.body, "1×2 e 4×3"
  end

  test "creates the second stage through the modal endpoint" do
    post create_tranca_second_stage_championship_path(@championship), params: { groups: @groups }

    assert_redirected_to rodadas_championship_path(@championship)
    assert_equal 3, @championship.tranca_rodadas.for_stage(2).count
    assert_equal 24, @championship.tranca_partidas.for_stage(2).count
    assert_equal 8, @championship.tranca_rodadas.for_stage(2).find_by!(round_number: 1).mesas.count
  end

  test "rejects duplicated selections" do
    @groups["D"][3] = @groups["A"].first

    post create_tranca_second_stage_championship_path(@championship), params: { groups: @groups }

    assert_response :see_other
    assert_not @championship.tranca_partidas.for_stage(2).exists?
    assert_equal "A mesma dupla não pode aparecer em mais de uma posição da 2ª etapa.", flash[:alert]
  end
end
