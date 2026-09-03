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

  def duplicate_as_available!(name:)
    raise ArgumentError, "name required" if name.blank?

    self.class.transaction do
      duplicated_category = dup
      duplicated_category.source_id = "category-dup-#{source_id}-#{SecureRandom.hex(4)}"
      duplicated_category.name = name
      duplicated_category.championship = nil
      duplicated_category.save!

      teams.includes(:athletes).find_each do |team|
        duplicated_team = team.dup
        duplicated_team.source_id = "team-dup-#{team.source_id}-#{SecureRandom.hex(4)}"
        duplicated_team.category = duplicated_category
        duplicated_team.registration_status = :pendente
        duplicated_team.finance_status = :pendente
        duplicated_team.save!

        team.athletes.find_each do |athlete|
          duplicated_athlete = athlete.dup
          duplicated_athlete.source_id = "athlete-dup-#{athlete.source_id}-#{SecureRandom.hex(4)}"
          duplicated_athlete.team = duplicated_team
          duplicated_athlete.category = duplicated_category
          duplicated_athlete.user = nil
          duplicated_athlete.status = :pendente
          duplicated_athlete.registration_submitted_at = nil
          duplicated_athlete.save!
        end
      end

      duplicated_category
    end
  end

  def duplicate_to!(championship)
    raise ArgumentError, "championship required" if championship.blank?

    self.class.transaction do
      duplicated_category = dup
      duplicated_category.source_id = "category-dup-#{source_id}-#{SecureRandom.hex(4)}"
      duplicated_category.championship = championship
      duplicated_category.save!

      teams.includes(:athletes).find_each do |team|
        duplicated_team = team.dup
        duplicated_team.source_id = "team-dup-#{team.source_id}-#{SecureRandom.hex(4)}"
        duplicated_team.category = duplicated_category
        duplicated_team.registration_status = :pendente
        duplicated_team.finance_status = :pendente
        duplicated_team.save!

        team.athletes.find_each do |athlete|
          duplicated_athlete = athlete.dup
          duplicated_athlete.source_id = "athlete-dup-#{athlete.source_id}-#{SecureRandom.hex(4)}"
          duplicated_athlete.team = duplicated_team
          duplicated_athlete.category = duplicated_category
          duplicated_athlete.user = nil
          duplicated_athlete.status = :pendente
          duplicated_athlete.registration_submitted_at = nil
          duplicated_athlete.save!
        end
      end

      duplicated_category
    end
  end

  private

  def sync_primary_championship_link
    return if championship_id.blank?
    return unless self.class.connection.data_source_exists?("championship_categories")

    championship_categories.find_or_create_by!(championship_id: championship_id) do |membership|
      membership.source_id = "championship-category-#{championship_id}-#{id}"
    end
  end
end
