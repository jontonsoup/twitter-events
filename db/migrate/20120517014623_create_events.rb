class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.float :lat
      t.float :long
      t.string :location
      t.string :artist
      t.string :opener
      t.integer :number_of_people
      t.boolean :sold_out

      t.timestamps
    end
  end
end
