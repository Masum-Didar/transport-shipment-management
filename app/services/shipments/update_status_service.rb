module Shipments
  class UpdateStatusService
    def initialize(shipment, new_status, user:, remarks: nil)
      @shipment = shipment
      @new_status = new_status
      @user = user
      @remarks = remarks
    end

    def call
      return false unless valid_transition?

      Shipment.transaction do
        @shipment.update!(status: @new_status, actual_delivery_date: @new_status == "completed" ? Time.current : @shipment.actual_delivery_date)
        @shipment.status_logs.create!(
          status: @new_status,
          changed_by: @user,
          changed_at: Time.current,
          remarks: @remarks
        )
        event = @new_status == "completed" ? "completed" : "status_changed"
        ShipmentNotificationJob.perform_later(shipment_id: @shipment.id, event: event)
      end

      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    def valid_transition?
      transitions = {
        "pending"    => %w[loading],
        "loading"    => %w[loaded],
        "loaded"     => %w[on_the_way],
        "on_the_way" => %w[reached],
        "reached"    => %w[unloading],
        "unloading"  => %w[completed]
      }
      transitions[@shipment.status]&.include?(@new_status)
    end
  end
end
