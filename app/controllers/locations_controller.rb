class LocationsController < AuthenticatedController
  before_action :set_location, only: %i[edit update destroy]

  def index
    @locations = policy_scope(Location).kept.order(:name)
    @locations = @locations.where(location_type: params[:type]) if params[:type].present?
  end

  def new
    @location = Location.new
    authorize @location
  end

  def create
    @location = Location.new(location_params)
    authorize @location
    if @location.save
      redirect_to locations_path, notice: "Location added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: "Location updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.discard!
    redirect_to locations_path, notice: "Location removed successfully."
  end

  private

  def set_location
    @location = Location.kept.find(params[:id])
    authorize @location
  end

  def location_params
    params.require(:location).permit(:name, :address, :city, :division, :country, :location_type, :notes)
  end
end
