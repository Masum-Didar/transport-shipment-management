module Reports
  class DailyReportService < BaseService
    def initialize(date: Date.current)
      @date = date.is_a?(String) ? Date.parse(date) : date
    end

    def call
      shipments = Shipment.kept.where(shipment_date: @date)
      {
        date: @date,
        total: shipments.count,
        exports: shipments.exports.count,
        imports: shipments.imports.count,
        completed: shipments.where(status: "completed").count,
        on_way: shipments.where(status: "on_the_way").count,
        pending: shipments.where(status: "pending").count,
        shipments: shipments.includes(:truck, :source_location, :destination_location)
      }
    end
  end
end
