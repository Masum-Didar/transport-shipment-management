class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.string :shipment_number, null: false
      t.string :shipment_type, null: false
      t.string :status, null: false, default: "pending"
      t.references :source_location, foreign_key: { to_table: :locations }
      t.references :destination_location, foreign_key: { to_table: :locations }
      t.references :route, foreign_key: true
      t.references :truck, foreign_key: true
      t.date :shipment_date, null: false, default: -> { "CURRENT_DATE" }
      t.date :estimated_delivery_date
      t.date :actual_delivery_date
      t.text :notes
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :shipments, :shipment_number, unique: true
    add_index :shipments, :status
    add_index :shipments, :shipment_type
    add_index :shipments, :shipment_date
    add_index :shipments, :discarded_at
    add_index :shipments, [:shipment_type, :status, :shipment_date], name: "idx_shipments_type_status_date"
  end
end
