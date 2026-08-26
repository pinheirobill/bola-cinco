class DropNewsItems < ActiveRecord::Migration[8.1]
  def change
    drop_table :news_items if table_exists?(:news_items)
  end
end
