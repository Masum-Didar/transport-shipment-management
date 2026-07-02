module Auditable
  extend ActiveSupport::Concern

  included do
    after_create :log_create
    after_update :log_update
    after_discard :log_discard if respond_to?(:discard)
  end

  private

  def log_create
    create_audit_log("create")
  end

  def log_update
    return if saved_changes.empty?
    create_audit_log("update", saved_changes)
  end

  def log_discard
    create_audit_log("delete", { discarded_at: Time.current })
  end

  def create_audit_log(action, changes = nil)
    audit_logs.create!(
      user: Current.user,
      action: action,
      auditable_type: self.class.name,
      auditable_id: id,
      audited_changes: changes,
      ip_address: Current.ip_address,
      user_agent: Current.user_agent
    )
  rescue
    nil
  end
end
