class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :event_type
      t.datetime :starts_at
      t.string :location
      t.string :ticket_url
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
