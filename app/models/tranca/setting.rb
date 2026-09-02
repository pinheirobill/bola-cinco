module Tranca
  class Setting < ApplicationRecord
    self.table_name = "tranca_settings"

    belongs_to :championship

    validates :source_id, presence: true, uniqueness: true
  end
end
