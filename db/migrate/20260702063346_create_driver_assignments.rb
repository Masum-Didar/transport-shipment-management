class CreateDriverAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :driver_assignments do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :truck, null: false, foreign_key: true
      t.references :assigned_by, null: false, foreign_key: { to_table: :users }
      t.datetime :assigned_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :released_at
      t.string :release_reason
      t.text :notes

      t.timestamps
    end
    add_index :driver_assignments, [:driver_id, :released_at]
    add_index :driver_assignments, [:truck_id, :released_at]
  end
end
