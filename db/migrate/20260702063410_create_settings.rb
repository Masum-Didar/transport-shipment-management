class CreateSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :settings do |t|
      t.string :key, null: false
      t.text :value
      t.string :setting_type, default: "string"
      t.string :group
      t.text :description

      t.timestamps
    end
    add_index :settings, :key, unique: true
    add_index :settings, :group
  end
end
