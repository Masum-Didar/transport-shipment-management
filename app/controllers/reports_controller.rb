class ReportsController < ApplicationController
  before_action :authorize_report

  def daily
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @shipments = Shipment.kept.where(shipment_date: @date)
    @exports = @shipments.exports.count
    @imports = @shipments.imports.count
    @completed = @shipments.where(status: "completed").count
    @on_way = @shipments.where(status: "on_the_way").count
    respond_to_format("Daily_Report_#{@date}")
  end

  def weekly
    @week_start = params[:date].present? ? Date.parse(params[:date]).beginning_of_week : Date.current.beginning_of_week
    @week_end = @week_start.end_of_week
    @shipments = Shipment.kept.where(shipment_date: @week_start..@week_end)
    @grouped = @shipments.group(:shipment_date).group(:shipment_type).count
    respond_to_format("Weekly_Report_#{@week_start}_#{@week_end}")
  end

  def monthly
    @month = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @shipments = Shipment.kept.where(shipment_date: @month.beginning_of_month..@month.end_of_month)
    @grouped = @shipments.group(:shipment_type).group(:status).count
    respond_to_format("Monthly_Report_#{@month.strftime('%B_%Y')}")
  end

  def truck_wise
    @truck = Truck.kept.find(params[:truck_id]) if params[:truck_id].present?
    @shipments = @truck ? @truck.shipments.kept : Shipment.kept
    @shipments = @shipments.where(shipment_date: date_range) if params[:from_date].present?
    @grouped = @shipments.group(:truck_id, :status).count
    respond_to_format("Truck_Wise_Report")
  end

  def driver_wise
    @driver = Driver.kept.find(params[:driver_id]) if params[:driver_id].present?
    @assignments = @driver ? @driver.driver_assignments : DriverAssignment
    @assignments = @assignments.where(assigned_at: date_range) if params[:from_date].present?
    respond_to_format("Driver_Wise_Report")
  end

  def product_wise
    @product = Product.kept.find(params[:product_id]) if params[:product_id].present?
    @items = @product ? @product.shipment_items : ShipmentItem
    @items = @items.joins(:shipment).where(shipments: { shipment_date: date_range }) if params[:from_date].present?
    @grouped = @items.group(:product_id).sum(:quantity)
    respond_to_format("Product_Wise_Report")
  end

  private

  def authorize_report
    authorize :report, :daily?
  end

  def date_range
    (Date.parse(params[:from_date])..Date.parse(params[:to_date]))
  rescue
    nil
  end

  def respond_to_format(filename)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: filename, template: "reports/#{action_name}", layout: "pdf"
      end
      format.xlsx do
        render xlsx: filename, template: "reports/#{action_name}", filename: "#{filename}.xlsx"
      end
      format.csv do
        send_data generate_csv, filename: "#{filename}.csv"
      end
    end
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << ["Shipment #", "Type", "Status", "Source", "Destination", "Date"]
      @shipments.each do |s|
        csv << [s.shipment_number, s.shipment_type, s.status,
                s.source_location&.name, s.destination_location&.name, s.shipment_date]
      end
    end
  end
end
