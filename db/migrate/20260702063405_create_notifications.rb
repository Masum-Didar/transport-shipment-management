class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type, null: false
      t.string :title, null: false
      t.text :message
      t.boolean :read, default: false
      t.datetime :read_at
      t.string :notifiable_type
      t.integer :notifiable_id

      t.timestamps
    end
    add_index :notifications, [:user_id, :read]
    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
