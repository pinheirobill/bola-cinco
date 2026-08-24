class Entity < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true
end
