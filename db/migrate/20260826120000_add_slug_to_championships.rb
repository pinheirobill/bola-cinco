class AddSlugToChampionships < ActiveRecord::Migration[8.1]
  def up
    add_column :championships, :slug, :string
    add_index :championships, :slug, unique: true

    Championship.reset_column_information
    Championship.find_each do |championship|
      slug = [championship.name, championship.season].compact.join(" ").parameterize
      slug = "#{slug}-#{championship.source_id.parameterize}" if Championship.where.not(id: championship.id).exists?(slug: slug)
      championship.update_columns(slug: slug)
    end
  end

  def down
    remove_index :championships, :slug
    remove_column :championships, :slug
  end
end
