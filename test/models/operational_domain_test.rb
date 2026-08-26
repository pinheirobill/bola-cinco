require "test_helper"

class OperationalDomainTest < ActiveSupport::TestCase
  def setup
    @championship = Championship.create!(
      source_id: "champ-1",
      name: "Campeonato Base",
      season: 2026
    )

    @category = Category.create!(
      source_id: "cat-1",
      championship: @championship,
      name: "Sub 12"
    )

    @entity = Entity.create!(
      source_id: "entity-1",
      name: "Time Base"
    )

    @team = Team.create!(
      source_id: "team-1",
      entity: @entity,
      category: @category,
      name: "Time Base"
    )

    @athlete = Athlete.create!(
      source_id: "athlete-1",
      team: @team,
      category: @category,
      name: "Jogador Base"
    )
  end

  test "venue belongs to a championship and defaults to ativo" do
    venue = Venue.create!(
      source_id: "venue-1",
      championship: @championship,
      name: "Ginásio Central"
    )

    assert venue.status_ativo?
    assert_equal @championship, venue.championship
  end

  test "venue can be unassigned from a championship" do
    venue = Venue.create!(
      source_id: "venue-2",
      name: "Quadra Livre"
    )

    assert_nil venue.championship
    assert venue.status_ativo?
  end

  test "referee belongs to a championship" do
    referee = Referee.create!(
      source_id: "ref-1",
      championship: @championship,
      name: "Árbitro Base"
    )

    assert_equal @championship, referee.championship
  end

  test "referee can be unassigned from a championship" do
    referee = Referee.create!(
      source_id: "ref-2",
      name: "Árbitro Livre"
    )

    assert_nil referee.championship
  end

  test "match_event can be linked to match team and athlete" do
    match = Match.create!(
      source_id: "match-1",
      championship: @championship,
      category: @category,
      code: "J1",
      phase: "grupos"
    )

    event = MatchEvent.create!(
      source_id: "event-1",
      match: match,
      team: @team,
      athlete: @athlete,
      kind: :gol,
      minute: 12
    )

    assert event.kind_gol?
    assert_equal @championship, event.championship
    assert_equal match, event.match
    assert_equal @team, event.team
    assert_equal @athlete, event.athlete
  end

  test "match_event can belong to a championship without a match" do
    event = MatchEvent.create!(
      source_id: "event-2",
      championship: @championship,
      team: @team,
      athlete: @athlete,
      kind: :assistencia,
      minute: 7
    )

    assert_equal @championship, event.championship
    assert_nil event.match
  end

end
