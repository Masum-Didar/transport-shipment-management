class CreateShipmentStatusLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :shipment_status_logs do |t|
      t.references :shipment, null: false, foreign_key: true
      t.string :status, null: false
      t.references :changed_by, null: false, foreign_key: { to_table: :users }
      t.datetime :changed_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.text :remarks

      t.timestamps
    end
    add_index :shipment_status_logs, [:shipment_id, :changed_at]
  end
end
