class ChampionshipGroupStageRedrawJob < ApplicationJob
  queue_as :default

  def perform(championship_id, token)
    championship = Championship.find(championship_id)
    return unless championship.mark_group_stage_redraw_started!(token)

    matches = championship.redraw_group_stage!
    championship.complete_group_stage_redraw!(token,
      match_count: matches.size,
      round_count: matches.map(&:round_number).compact.uniq.size)
  rescue StandardError => error
    message = if error.is_a?(ArgumentError)
      error.message
    else
      "Não foi possível refazer o sorteio. Confira os logs do worker."
    end
    championship&.record_group_stage_redraw_failure!(token, message)
    raise
  end
end
