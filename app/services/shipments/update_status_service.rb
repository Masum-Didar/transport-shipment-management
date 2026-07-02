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
        create_notification if @new_status == "completed"
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

    def create_notification
      admin_users = User.joins(:role).where(roles: { name: %w[super_admin admin] })
      admin_users.each do |admin|
        Notification.create!(
          user: admin,
          type: "shipment_completed",
          title: "Shipment Completed",
          message: "#{@shipment.shipment_number} has been completed.",
          notifiable: @shipment
        )
      end
    end
  end
end
