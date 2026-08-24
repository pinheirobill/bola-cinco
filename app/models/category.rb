class Category < ApplicationRecord
  belongs_to :championship
  has_many :teams, dependent: :destroy
  has_many :athletes, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :standing_rows, dependent: :destroy
  has_many :invoices, dependent: :nullify

  enum :gender, {
    masculino: "masculino",
    feminino: "feminino",
    misto: "misto"
  }, prefix: true

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true
end
