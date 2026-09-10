require "test_helper"

class Tranca::RoundRobinPairingsTest < ActiveSupport::TestCase
  test "five participants match the supplied first round" do
    assert_equal [[2, 5], [3, 4]], Tranca::RoundRobinPairings.new((1..5).to_a).round(1)
  end

  test "complete schedules have every pair once and balanced byes" do
    [2, 3, 5, 6, 43, 48].each do |size|
      players = (1..size).to_a
      schedule = Tranca::RoundRobinPairings.new(players)
      pairs = []
      byes = []
      (1..schedule.rounds_count).each do |number|
        games = schedule.round(number)
        assert_equal size / 2, games.size
        assert_equal games.flatten.uniq, games.flatten
        pairs.concat(games.map(&:sort))
        byes.concat(players - games.flatten)
      end
      assert_equal players.combination(2).to_a.sort, pairs.sort
      assert_equal(size.odd? ? players : [], byes.sort)
      assert_empty schedule.round(schedule.rounds_count + 1)
    end
  end
end
