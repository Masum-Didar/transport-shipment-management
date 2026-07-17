class DriverAssignment < ApplicationRecord
  include Auditable
  belongs_to :driver
  belongs_to :truck
  belongs_to :assigned_by, class_name: "User"

  validates :assigned_at, presence: true

  scope :current, -> { where(released_at: nil) }
  scope :completed, -> { where.not(released_at: nil) }

  def duration
    return nil unless released_at
    (released_at - assigned_at).to_i / 3600
  end
end
