class CreateStaticPageContents < ActiveRecord::Migration[8.1]
  def change
    create_table :static_page_contents do |t|
      t.string :slug, null: false
      t.text :content
      t.timestamps
    end
    add_index :static_page_contents, :slug, unique: true
  end
end
