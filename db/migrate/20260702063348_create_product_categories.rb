class CreateProductCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :product_categories do |t|
      t.string :name, null: false
      t.text :description
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :product_categories, :name, unique: true, where: "discarded_at IS NULL"
    add_index :product_categories, :discarded_at
  end
end
