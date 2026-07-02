class CreateTrucks < ActiveRecord::Migration[8.1]
  def change
    create_table :trucks do |t|
      t.string :truck_number, null: false
      t.string :truck_type, null: false, default: "company"
      t.string :status, null: false, default: "available"
      t.string :brand
      t.string :vehicle_model
      t.integer :year
      t.decimal :capacity_kg, precision: 10, scale: 2
      t.references :current_location, foreign_key: { to_table: :locations }
      t.text :notes
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :trucks, :truck_number, unique: true, where: "discarded_at IS NULL"
    add_index :trucks, :status
    add_index :trucks, :truck_type
    add_index :trucks, :discarded_at
  end
end
