class Truck < ApplicationRecord
  include Discard::Model

  belongs_to :current_location, class_name: "Location", optional: true
  has_many :location_logs, class_name: "TruckLocationLog", dependent: :destroy
  has_many :driver_assignments, dependent: :destroy
  has_many :drivers, through: :driver_assignments
  has_many :shipments, dependent: :restrict_with_error

  validates :truck_number, presence: true, uniqueness: true
  validates :truck_type, inclusion: { in: %w[company outside] }
  validates :status, inclusion: { in: %w[available assigned loading on_route maintenance inactive] }

  scope :active, -> { kept }
  scope :available, -> { kept.where(status: "available") }
  scope :by_type, ->(type) { where(truck_type: type) }

  def current_driver
    driver_assignments.where(released_at: nil).last&.driver
  end

  def current_shipment
    shipments.kept.where.not(status: %w[completed]).last
  end

  def display_name
    "#{truck_number} (#{truck_type.titleize})"
  end
end
