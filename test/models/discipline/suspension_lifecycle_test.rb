require "test_helper"

class Discipline::SuspensionLifecycleTest < ActiveSupport::TestCase
  setup do
    @championship = Championship.create!(
      source_id: "champ-lifecycle",
      name: "Campeonato Lifecycle",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-lifecycle",
      championship: @championship,
      name: "Sub 18"
    )

    @entity = Entity.create!(
      source_id: "entity-lifecycle",
      name: "Time Lifecycle"
    )

    @team = Team.create!(
      source_id: "team-lifecycle",
      entity: @entity,
      category: @category,
      name: "Time Lifecycle"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-lifecycle",
      team: @team,
      category: @category,
      name: "Atleta Lifecycle"
    )
  end

  test "sweeps expired suspensions to fulfilled" do
    suspension = Suspension.create!(
      source_id: "susp-lifecycle",
      championship: @championship,
      category: @category,
      team: @team,
      athlete: @athlete,
      reason: "Suspensão expirada",
      ends_on: Date.current - 1.day
    )

    Discipline::SuspensionLifecycle.new(championship: @championship).sweep_expired!

    assert suspension.reload.status_cumprida?
    assert_equal "expiration", suspension.source_data["closed_by"]
  end

  test "does not sweep future suspensions" do
    suspension = Suspension.create!(
      source_id: "susp-future",
      championship: @championship,
      category: @category,
      team: @team,
      athlete: @athlete,
      reason: "Suspensão futura",
      ends_on: Date.current + 1.day
    )

    Discipline::SuspensionLifecycle.new(championship: @championship).sweep_expired!

    assert suspension.reload.status_ativa?
  end
end
