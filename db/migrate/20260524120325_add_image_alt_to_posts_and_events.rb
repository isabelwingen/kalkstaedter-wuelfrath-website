class AddImageAltToPostsAndEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :image_alt, :string
    add_column :events, :image_alt, :string
  end
end
