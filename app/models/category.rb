class Category < ApplicationRecord
  belongs_to :championship, optional: true
  has_many :championship_categories, dependent: :delete_all
  has_many :championships, through: :championship_categories
  has_many :teams, dependent: :destroy
  has_many :athletes, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :standing_rows, dependent: :destroy
  has_many :invoices, dependent: :nullify

  after_commit :sync_primary_championship_link, on: %i[create update]

  enum :gender, {
    masculino: "masculino",
    feminino: "feminino",
    misto: "misto"
  }, prefix: true

  validates :source_id, :name, presence: true
  validates :source_id, uniqueness: true

  scope :for_championship, ->(championship) { joins(:championships).where(championships: { id: championship.is_a?(Championship) ? championship.id : championship }).distinct }

  def championship_name
    championship&.name || championships.first&.name
  end

  private

  def sync_primary_championship_link
    return if championship_id.blank?

    championship_categories.find_or_create_by!(championship_id: championship_id) do |membership|
      membership.source_id = "championship-category-#{championship_id}-#{id}"
    end
  end
end
