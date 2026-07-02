class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.text :address
      t.string :city
      t.string :division
      t.string :country, default: "Bangladesh"
      t.string :location_type, null: false
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.text :notes
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :locations, :name
    add_index :locations, :location_type
    add_index :locations, :discarded_at
  end
end
