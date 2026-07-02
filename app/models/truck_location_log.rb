class TruckLocationLog < ApplicationRecord
  belongs_to :truck
  belongs_to :updated_by, class_name: "User", optional: true

  validates :location, presence: true
  validates :logged_at, presence: true
end
