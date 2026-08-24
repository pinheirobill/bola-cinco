class AddHighlightVideosToMatches < ActiveRecord::Migration[8.1]
  def change
    add_column :matches, :highlight_videos, :json, null: false, default: []
  end
end
