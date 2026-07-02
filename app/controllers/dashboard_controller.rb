class DashboardController < AuthenticatedController
  skip_after_action :verify_authorized, only: :index
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @today_export   = Shipment.kept.exports.today.count
    @today_import   = Shipment.kept.imports.today.count
    @active_trucks  = Truck.kept.where(status: "on_route").count
    @completed_today  = Shipment.kept.where(status: "completed", actual_delivery_date: Date.current).count
    @pending_shipments = Shipment.kept.where(status: "pending").count
    @loading_trucks = Truck.kept.where(status: "loading").count
    @reached_shipments = Shipment.kept.where(status: "reached").count

    @total_trucks = Truck.kept.count
    @drivers_on_duty = Driver.kept.where(status: "driving").count
    @active_shipments = Shipment.kept.where.not(status: "completed").count

    total = Shipment.kept.where(shipment_date: Date.current).count
    @completed_percentage = total > 0 ? ((@completed_today.to_f / total) * 100).round(1) : 0

    @recent_shipments = Shipment.kept.includes(:truck, :source_location, :destination_location)
                            .order(created_at: :desc).limit(5)

    @status_counts = Shipment.kept.group(:status).count

    @top_routes = Shipment.kept.joins(:route)
                         .group("routes.id", "routes.from_location_id", "routes.to_location_id")
                         .order("count_all DESC")
                         .limit(5)
                         .count
                         .map { |(route_id, f_id, t_id), count|
                           route = Route.find(route_id)
                           { name: route.display_name, count: count }
                         }

    @weekly_data = (Date.current.beginning_of_week..Date.current.end_of_week).map do |day|
      exports = Shipment.kept.exports.where(shipment_date: day).count
      imports = Shipment.kept.imports.where(shipment_date: day).count
      { day: day.strftime("%a"), export: exports, import: imports }
    end
  end
end
