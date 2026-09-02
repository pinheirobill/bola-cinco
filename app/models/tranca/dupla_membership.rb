module Tranca
  class DuplaMembership < ApplicationRecord
    self.table_name = "tranca_dupla_memberships"

    belongs_to :tranca_dupla, class_name: "Tranca::Dupla"
    belongs_to :athlete

    validates :source_id, presence: true, uniqueness: true
  end
end
