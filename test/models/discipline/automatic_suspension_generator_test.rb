require "test_helper"

class Discipline::AutomaticSuspensionGeneratorTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-discipline",
      name: "Campeonato Disciplina",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-discipline",
      championship: @championship,
      name: "Sub 16"
    )

    @entity = Entity.create!(
      source_id: "entity-discipline",
      name: "Time Disciplina"
    )

    @team = Team.create!(
      source_id: "team-discipline",
      entity: @entity,
      category: @category,
      name: "Time Disciplina"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-discipline",
      team: @team,
      category: @category,
      name: "Atleta Disciplina"
    )

    @match_1 = Match.create!(
      source_id: "match-discipline-1",
      championship: @championship,
      category: @category,
      code: "R1",
      phase: "grupos",
      scheduled_on: Date.new(2026, 8, 1)
    )

    @match_2 = Match.create!(
      source_id: "match-discipline-2",
      championship: @championship,
      category: @category,
      code: "R2",
      phase: "grupos",
      scheduled_on: Date.new(2026, 8, 8)
    )

    @match_3 = Match.create!(
      source_id: "match-discipline-3",
      championship: @championship,
      category: @category,
      code: "R3",
      phase: "grupos",
      scheduled_on: Date.new(2026, 8, 15)
    )
  end

  test "creates a suspension after three yellow cards" do
    create_yellow(@match_1, "event-1")
    create_yellow(@match_2, "event-2")
    create_yellow(@match_3, "event-3")

    suspensions = Suspension.where(championship: @championship, athlete: @athlete)

    assert_equal 1, suspensions.count
    assert suspensions.first.automatic?
    assert_equal "Acúmulo de cartões amarelos (3)", suspensions.first.reason
  end

  test "creates a suspension for a red card" do
    MatchEvent.create!(
      source_id: "red-event",
      match: @match_1,
      team: @team,
      athlete: @athlete,
      kind: :cartao_vermelho
    )

    Discipline::AutomaticSuspensionGenerator.new(championship: @championship).call

    suspension = Suspension.find_by(championship: @championship, athlete: @athlete)

    assert suspension.automatic?
    assert_equal "Cartão vermelho direto", suspension.reason
  end

  private

  def create_yellow(match, source_id)
    MatchEvent.create!(
      source_id: source_id,
      match: match,
      team: @team,
      athlete: @athlete,
      kind: :cartao_amarelo
    )

    Discipline::AutomaticSuspensionGenerator.new(championship: @championship).call
  end
end
