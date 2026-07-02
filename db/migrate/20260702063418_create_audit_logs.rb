class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs do |t|
      t.references :user, foreign_key: true
      t.string :action, null: false
      t.string :auditable_type, null: false
      t.integer :auditable_id, null: false
      t.jsonb :audited_changes
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
    add_index :audit_logs, [:auditable_type, :auditable_id]
    add_index :audit_logs, :created_at
  end
end
