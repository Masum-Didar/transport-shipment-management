class Driver < ApplicationRecord
  include Auditable
  include Discard::Model

  has_many :driver_assignments, dependent: :destroy
  has_many :trucks, through: :driver_assignments

  validates :name, :phone, presence: true
  validates :phone, uniqueness: true
  validates :status, inclusion: { in: %w[available driving leave inactive] }

  scope :active, -> { kept }
  scope :available, -> { kept.where(status: "available") }

  def current_truck
    driver_assignments.where(released_at: nil).last&.truck
  end

  def currently_assigned?
    driver_assignments.where(released_at: nil).exists?
  end

  def display_name
    "#{name} (#{phone})"
  end
end
