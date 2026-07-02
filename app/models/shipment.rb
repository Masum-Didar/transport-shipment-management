class Shipment < ApplicationRecord
  include Discard::Model

  belongs_to :source_location, class_name: "Location", optional: true
  belongs_to :destination_location, class_name: "Location", optional: true
  belongs_to :route, optional: true
  belongs_to :truck, optional: true
  belongs_to :created_by, class_name: "User"

  has_many :shipment_items, dependent: :destroy
  has_many :products, through: :shipment_items
  has_many :status_logs, class_name: "ShipmentStatusLog", dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :shipment_number, presence: true, uniqueness: true
  validates :shipment_type, inclusion: { in: %w[import export] }
  validates :status, inclusion: {
    in: %w[pending loading loaded on_the_way reached unloading completed]
  }
  validates :shipment_date, presence: true

  scope :active, -> { kept }
  scope :imports, -> { where(shipment_type: "import") }
  scope :exports, -> { where(shipment_type: "export") }
  scope :by_status, ->(status) { where(status: status) }
  scope :today, -> { where(shipment_date: Date.current) }
  scope :this_week, -> { where(shipment_date: Date.current.all_week) }
  scope :this_month, -> { where(shipment_date: Date.current.all_month) }

  def display_name
    shipment_number
  end

  def total_weight
    shipment_items.sum(:weight)
  end

  def total_quantity
    shipment_items.sum(:quantity)
  end

  def update_status(new_status, user:, remarks: nil)
    return false unless valid_transition?(new_status)

    transaction do
      update!(status: new_status)
      status_logs.create!(
        status: new_status,
        changed_by: user,
        changed_at: Time.current,
        remarks: remarks
      )
      update!(actual_delivery_date: Time.current) if new_status == "completed"
    end
    true
  end

  private

  def valid_transition?(new_status)
    transitions = {
      "pending"    => %w[loading],
      "loading"    => %w[loaded],
      "loaded"     => %w[on_the_way],
      "on_the_way" => %w[reached],
      "reached"    => %w[unloading],
      "unloading"  => %w[completed],
      "completed"  => %w[]
    }
    transitions[status]&.include?(new_status)
  end
end
