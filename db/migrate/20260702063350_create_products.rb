class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.references :product_category, foreign_key: true
      t.string :default_unit, null: false, default: "kg"
      t.text :description
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :products, :name
    add_index :products, :discarded_at
  end
end
