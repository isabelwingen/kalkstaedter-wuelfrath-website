class CreatePressLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :press_links do |t|
      t.string :title
      t.string :url
      t.string :publication
      t.date :published_on

      t.timestamps
    end
  end
end
