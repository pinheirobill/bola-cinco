class SyncFootballKnockoutBracketsJob < ApplicationJob
  queue_as :default

  def perform
    Championship.for_modality(:football).find_each do |championship|
      championship.sync_knockout_brackets!
    end
  end
end
