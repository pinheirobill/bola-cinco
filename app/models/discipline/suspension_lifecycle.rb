module Discipline
  class SuspensionLifecycle
    def initialize(championship:)
      @championship = championship
    end

    def sweep_expired!
      expired_suspensions.find_each do |suspension|
        suspension.update!(
          status: :cumprida,
          source_data: suspension.source_data.merge(
            "closed_by" => "expiration",
            "closed_at" => Time.current.iso8601
          )
        )
      end
    end

    private

    attr_reader :championship

    def expired_suspensions
      championship.suspensions.status_ativa.where.not(ends_on: nil).where("ends_on <= ?", Date.current)
    end
  end
end
