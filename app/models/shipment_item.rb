class ShipmentItem < ApplicationRecord
  belongs_to :shipment
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
end
