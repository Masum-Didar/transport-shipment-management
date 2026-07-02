class ShipmentStatusLog < ApplicationRecord
  belongs_to :shipment
  belongs_to :changed_by, class_name: "User"

  validates :status, :changed_at, presence: true

  scope :chronological, -> { order(changed_at: :asc) }
end
