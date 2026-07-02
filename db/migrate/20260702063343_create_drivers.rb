class CreateDrivers < ActiveRecord::Migration[8.1]
  def change
    create_table :drivers do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.string :alternative_phone
      t.text :address
      t.string :license_number
      t.string :status, null: false, default: "available"
      t.text :notes
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :drivers, :phone, unique: true, where: "discarded_at IS NULL"
    add_index :drivers, :status
    add_index :drivers, :discarded_at
  end
end
