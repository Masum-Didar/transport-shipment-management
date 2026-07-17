class TrucksController < AuthenticatedController
  before_action :set_truck, only: %i[show edit update destroy update_location]

  def index
    @trucks = policy_scope(Truck).kept
    @trucks = @trucks.where(status: params[:status]) if params[:status].present?
    @trucks = @trucks.where(truck_type: params[:type]) if params[:type].present?
    @trucks = @trucks.ransack(truck_number_or_brand_cont: params[:q]).result if params[:q].present?
    @trucks = @trucks.order(created_at: :desc)
  end

  def show
    @current_shipment = @truck.current_shipment
  end

  def new
    @truck = Truck.new
    authorize @truck
  end

  def create
    @truck = Truck.new(truck_params)
    authorize @truck
    if @truck.save
      redirect_to @truck, notice: "Truck added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @truck.update(truck_params)
      redirect_to @truck, notice: "Truck updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @truck.discard!
    redirect_to trucks_path, notice: "Truck removed successfully."
  end

  def update_location
    if @truck.update(current_location_id: params[:location_id])
      @truck.location_logs.create!(
        location: @truck.current_location&.name,
        logged_at: Time.current,
        updated_by: current_user
      )
      redirect_to @truck, notice: "Location updated."
    else
      redirect_to @truck, alert: "Failed to update location."
    end
  end

  private

  def set_truck
    @truck = Truck.kept.find(params[:id])
    authorize @truck
  end

  def truck_params
    params.require(:truck).permit(:truck_number, :truck_type, :status, :brand, :vehicle_model,
                                  :year, :capacity_kg, :current_location_id, :notes)
  end
end
