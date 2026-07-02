class ShipmentItem < ApplicationRecord
  belongs_to :shipment, inverse_of: :shipment_items
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
end
