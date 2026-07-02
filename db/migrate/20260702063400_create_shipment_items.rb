class CreateShipmentItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shipment_items do |t|
      t.references :shipment, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :quantity, precision: 12, scale: 2, null: false
      t.decimal :weight, precision: 12, scale: 2
      t.string :unit, null: false
      t.text :remarks

      t.timestamps
    end
    add_index :shipment_items, [:shipment_id, :product_id]
  end
end
