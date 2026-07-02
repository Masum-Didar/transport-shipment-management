class ShipmentNotificationJob < ApplicationJob
  queue_as :notifications

  def perform(shipment_id:, event:)
    shipment = Shipment.kept.find_by(id: shipment_id)
    return unless shipment

    admin_users = User.joins(:role).where(roles: { name: %w[super_admin admin] })

    message = case event
    when "created"
      "New #{shipment.shipment_type.titleize} Shipment #{shipment.shipment_number}: #{shipment.source_location&.name} → #{shipment.destination_location&.name}"
    when "completed"
      "#{shipment.shipment_number} has been completed."
    when "status_changed"
      "#{shipment.shipment_number} status changed to #{shipment.status.titleize}"
    end

    return unless message

    admin_users.each do |user|
      NotificationJob.perform_later(
        type: "shipment_#{event}",
        title: "Shipment #{event.titleize}",
        message: message,
        user_id: user.id,
        notifiable_type: "Shipment",
        notifiable_id: shipment.id
      )
    end
  end
end
