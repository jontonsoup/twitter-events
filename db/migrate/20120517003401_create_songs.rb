class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :event_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
