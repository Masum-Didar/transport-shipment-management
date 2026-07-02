class Product < ApplicationRecord
  include Discard::Model

  belongs_to :product_category, optional: true
  has_many :shipment_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :default_unit, presence: true

  scope :active, -> { kept }

  def display_name
    name
  end
end
