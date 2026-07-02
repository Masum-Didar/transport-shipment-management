class CreateTruckLocationLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :truck_location_logs do |t|
      t.references :truck, null: false, foreign_key: true
      t.string :location, null: false
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.datetime :logged_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.references :updated_by, foreign_key: { to_table: :users }
      t.text :notes

      t.timestamps
    end
    add_index :truck_location_logs, [:truck_id, :logged_at]
  end
end
