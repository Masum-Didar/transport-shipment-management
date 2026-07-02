class DashboardController < AuthenticatedController
  skip_after_action :verify_authorized, only: :index
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @today_export   = Shipment.kept.exports.today.count
    @today_import   = Shipment.kept.imports.today.count
    @active_trucks  = Truck.kept.where(status: "on_route").count
    @loading_trucks = Truck.kept.where(status: "loading").count
    @reached_shipments = Shipment.kept.where(status: "reached").count
    @completed_today  = Shipment.kept.completed.where(actual_delivery_date: Date.current).count
    @pending_shipments = Shipment.kept.where(status: "pending").count

    total = Shipment.kept.where(shipment_date: Date.current).count
    @completed_percentage = total > 0 ? ((@completed_today.to_f / total) * 100).round(1) : 0

    @recent_shipments = Shipment.kept.includes(:truck, :source_location, :destination_location)
                            .order(created_at: :desc).limit(5)
  end
end
