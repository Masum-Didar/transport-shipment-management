class AuditLog < ApplicationRecord
  belongs_to :user, optional: true

  validates :action, :auditable_type, :auditable_id, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :for_auditable, ->(type, id) { where(auditable_type: type, auditable_id: id) }
end
