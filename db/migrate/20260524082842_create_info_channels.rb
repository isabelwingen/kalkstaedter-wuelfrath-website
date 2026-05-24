class CreateInfoChannels < ActiveRecord::Migration[8.1]
  def change
    create_table :info_channels do |t|
      t.string :name
      t.string :url
      t.string :platform

      t.timestamps
    end
  end
end
