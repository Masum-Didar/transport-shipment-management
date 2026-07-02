class User < ApplicationRecord
  include Discard::Model

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  belongs_to :role
  has_many :shipments, foreign_key: :created_by_id, dependent: :restrict_with_error
  has_many :assigned_assignments, class_name: "DriverAssignment", foreign_key: :assigned_by_id, dependent: :nullify
  has_many :status_logs, class_name: "ShipmentStatusLog", foreign_key: :changed_by_id, dependent: :nullify
  has_many :location_logs, class_name: "TruckLocationLog", foreign_key: :updated_by_id, dependent: :nullify
  has_many :notifications, dependent: :destroy
  has_many :audit_logs, dependent: :nullify

  validates :name, presence: true
  validates :status, inclusion: { in: %w[active inactive] }

  def admin?
    role.name.in?(%w[super_admin admin])
  end

  def super_admin?
    role.name == "super_admin"
  end

  def display_name
    name.presence || email
  end
end
