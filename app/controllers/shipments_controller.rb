class ShipmentsController < ApplicationController
  before_action :set_shipment, only: %i[show edit update destroy update_status]

  def index
    @shipments = policy_scope(Shipment).kept.includes(:truck, :source_location, :destination_location, :created_by)
    @shipments = @shipments.where(shipment_type: params[:type]) if params[:type].present?
    @shipments = @shipments.where(status: params[:status]) if params[:status].present?
    if params[:from_date].present? && params[:to_date].present?
      @shipments = @shipments.where(shipment_date: params[:from_date]..params[:to_date])
    end
    @shipments = @shipments.ransack(shipment_number_cont: params[:q]).result if params[:q].present?
    @shipments = @shipments.order(created_at: :desc)
  end

  def show
    @status_logs = @shipment.status_logs.includes(:changed_by).chronological
    @items = @shipment.shipment_items.includes(:product)
  end

  def new
    @shipment = Shipment.new
    @shipment.shipment_items.build
    authorize @shipment
  end

  def create
    @shipment = Shipment.new(shipment_params)
    @shipment.created_by = current_user
    @shipment.shipment_number = generate_shipment_number
    @shipment.status = "pending"
    authorize @shipment

    if @shipment.save
      @shipment.status_logs.create!(status: "pending", changed_by: current_user, changed_at: Time.current)
      redirect_to @shipment, notice: "Shipment created successfully."
    else
      @shipment.shipment_items.build if @shipment.shipment_items.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shipment.shipment_items.build if @shipment.shipment_items.empty?
  end

  def update
    if @shipment.update(shipment_params)
      redirect_to @shipment, notice: "Shipment updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shipment.discard!
    redirect_to shipments_path, notice: "Shipment removed successfully."
  end

  def update_status
    new_status = params[:status]
    remarks = params[:remarks]

    if @shipment.update_status(new_status, user: current_user, remarks: remarks)
      redirect_to @shipment, notice: "Status updated to #{new_status.titleize}."
    else
      redirect_to @shipment, alert: "Invalid status transition from #{@shipment.status} to #{new_status}."
    end
  end

  private

  def set_shipment
    @shipment = Shipment.kept.find(params[:id])
    authorize @shipment
  end

  def shipment_params
    params.require(:shipment).permit(:shipment_type, :source_location_id, :destination_location_id,
                                     :route_id, :truck_id, :shipment_date, :estimated_delivery_date,
                                     :notes,
                                     shipment_items_attributes: %i[id product_id quantity weight unit remarks _destroy])
  end

  def generate_shipment_number
    date_part = Date.current.strftime("%Y%m%d")
    count = Shipment.where("shipment_number LIKE ?", "SH-#{date_part}-%").count + 1
    "SH-#{date_part}-#{count.to_s.rjust(4, '0')}"
  end
end
