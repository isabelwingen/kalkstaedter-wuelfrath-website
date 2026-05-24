class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.date :published_at
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
