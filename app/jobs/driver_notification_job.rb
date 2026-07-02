class DriverNotificationJob < ApplicationJob
  queue_as :notifications

  def perform(driver_assignment_id:, event:)
    assignment = DriverAssignment.find_by(id: driver_assignment_id)
    return unless assignment

    case event
    when "assigned"
      title = "Driver Assigned"
      message = "#{assignment.driver.name} assigned to #{assignment.truck.truck_number}"
    when "released"
      title = "Driver Released"
      message = "#{assignment.driver.name} released from #{assignment.truck.truck_number}"
    end

    admin_users = User.joins(:role).where(roles: { name: %w[super_admin admin dispatcher] })
    admin_users.each do |user|
      NotificationJob.perform_later(
        type: "driver_#{event}",
        title: title,
        message: message,
        user_id: user.id
      )
    end
  end
end
