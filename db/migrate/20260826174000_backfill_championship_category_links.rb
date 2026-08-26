class BackfillChampionshipCategoryLinks < ActiveRecord::Migration[8.1]
  def up
    return unless table_exists?(:championship_categories)

    Category.find_each do |category|
      next if category.championship_id.blank?

      ChampionshipCategory.find_or_create_by!(championship_id: category.championship_id, category_id: category.id) do |membership|
        membership.source_id = "championship-category-#{category.championship_id}-#{category.id}"
      end
    end
  end

  def down
    # Keep the join rows in place. Removing them would drop existing championship/category links.
  end
end
