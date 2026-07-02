class CreateRoutes < ActiveRecord::Migration[8.1]
  def change
    create_table :routes do |t|
      t.references :from_location, null: false, foreign_key: { to_table: :locations }
      t.references :to_location, null: false, foreign_key: { to_table: :locations }
      t.decimal :distance_km, precision: 8, scale: 2
      t.decimal :estimated_hours, precision: 5, scale: 1
      t.text :notes
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :routes, [:from_location_id, :to_location_id], unique: true, where: "discarded_at IS NULL", name: "idx_routes_from_to_unique"
    add_index :routes, :discarded_at
  end
end
