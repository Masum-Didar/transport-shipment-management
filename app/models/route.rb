class Route < ApplicationRecord
  include Discard::Model

  belongs_to :from_location, class_name: "Location"
  belongs_to :to_location, class_name: "Location"
  has_many :shipments, dependent: :restrict_with_error

  validates :from_location_id, :to_location_id, presence: true
  validate :different_locations

  scope :active, -> { kept }

  def display_name
    "#{from_location.name} → #{to_location.name}"
  end

  private

  def different_locations
    if from_location_id == to_location_id
      errors.add(:to_location_id, "cannot be the same as source location")
    end
  end
end
