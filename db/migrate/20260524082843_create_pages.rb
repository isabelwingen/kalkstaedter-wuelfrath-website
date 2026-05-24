class CreatePages < ActiveRecord::Migration[8.1]
  def change
    create_table :pages do |t|
      t.string :slug, null: false
      t.index :slug, unique: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
