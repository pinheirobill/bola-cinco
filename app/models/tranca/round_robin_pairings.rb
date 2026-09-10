module Tranca
  # Berger rotation: the final seat is fixed, other seats advance by half
  # the table size. A nil seat represents a bye for an odd-sized field.
  class RoundRobinPairings
    def initialize(participants)
      @participants = participants.dup
      @participants << nil if @participants.size.odd?
    end

    def rounds_count
      [@participants.size - 1, 0].max
    end

    def round(number)
      return [] unless number.between?(1, rounds_count)

      size = @participants.size
      offset = ((number - 1) * (size / 2)) % (size - 1)
      seats = @participants.take(size - 1).rotate(offset) + [@participants.last]
      seats.take(size / 2).zip(seats.reverse.take(size / 2)).reject { |pair| pair.include?(nil) }
    end
  end
end
