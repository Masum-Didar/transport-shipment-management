module Shipments
  class CreateService
    def initialize(params, user)
      @params = params
      @user = user
    end

    def call
      shipment = Shipment.new(@params)
      shipment.created_by = @user
      shipment.shipment_number = generate_number
      shipment.status = "pending"

      Shipment.transaction do
        shipment.save!
        shipment.status_logs.create!(
          status: "pending",
          changed_by: @user,
          changed_at: Time.current
        )
        create_notification(shipment)
      end

      shipment
    rescue ActiveRecord::RecordInvalid => e
      e.record
    end

    private

    def generate_number
      date_part = Date.current.strftime("%Y%m%d")
      count = Shipment.where("shipment_number LIKE ?", "SH-#{date_part}-%").count + 1
      "SH-#{date_part}-#{count.to_s.rjust(4, '0')}"
    end

    def create_notification(shipment)
      Notification.create!(
        user: @user,
        type: "shipment_created",
        title: "New #{shipment.shipment_type.titleize} Shipment",
        message: "#{shipment.shipment_number}: #{shipment.source_location&.name} → #{shipment.destination_location&.name}",
        notifiable: shipment
      )
    end
  end
end
