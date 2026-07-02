class Location < ApplicationRecord
  include Auditable
  include Discard::Model

  has_many :routes_from, class_name: "Route", foreign_key: :from_location_id, dependent: :restrict_with_error
  has_many :routes_to, class_name: "Route", foreign_key: :to_location_id, dependent: :restrict_with_error
  has_many :source_shipments, class_name: "Shipment", foreign_key: :source_location_id, dependent: :restrict_with_error
  has_many :destination_shipments, class_name: "Shipment", foreign_key: :destination_location_id, dependent: :restrict_with_error
  has_many :trucks_at_location, class_name: "Truck", foreign_key: :current_location_id, dependent: :nullify

  validates :name, presence: true
  validates :location_type, inclusion: { in: %w[port icd warehouse factory border other] }

  scope :active, -> { kept }
  scope :by_type, ->(type) { where(location_type: type) }
end
