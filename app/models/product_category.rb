class ProductCategory < ApplicationRecord
  include Discard::Model

  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :active, -> { kept }
end
