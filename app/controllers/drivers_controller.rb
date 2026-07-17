class DriversController < AuthenticatedController
  before_action :set_driver, only: %i[show edit update destroy]

  def index
    @drivers = policy_scope(Driver).kept
    @drivers = @drivers.where(status: params[:status]) if params[:status].present?
    @drivers = @drivers.ransack(name_or_phone_cont: params[:q]).result if params[:q].present?
    @drivers = @drivers.order(created_at: :desc)
  end

  def show
    @current_truck = @driver.current_truck
  end

  def new
    @driver = Driver.new
    authorize @driver
  end

  def create
    @driver = Driver.new(driver_params)
    authorize @driver
    if @driver.save
      redirect_to @driver, notice: "Driver added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @driver.update(driver_params)
      redirect_to @driver, notice: "Driver updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @driver.discard!
    redirect_to drivers_path, notice: "Driver removed successfully."
  end

  private

  def set_driver
    @driver = Driver.kept.find(params[:id])
    authorize @driver
  end

  def driver_params
    params.require(:driver).permit(:name, :phone, :alternative_phone, :address, :license_number, :status, :notes)
  end
end
