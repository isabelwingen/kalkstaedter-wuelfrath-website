class AddEventIdToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :event, null: true, foreign_key: true
  end
end
