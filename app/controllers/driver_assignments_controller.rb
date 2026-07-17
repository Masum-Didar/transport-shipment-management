class DriverAssignmentsController < AuthenticatedController
  def index
    @assignments = policy_scope(DriverAssignment).includes(:driver, :truck, :assigned_by)
                        .order(assigned_at: :desc)
    @active_assignments = policy_scope(DriverAssignment).current.includes(:driver, :truck, :assigned_by)
    @available_drivers = Driver.kept.available
    @available_trucks = Truck.kept.available
  end

  def create
    @assignment = DriverAssignment.new(assignment_params)
    @assignment.assigned_by = current_user
    @assignment.assigned_at = Time.current
    authorize @assignment

    if @assignment.save
      @assignment.driver.update!(status: "driving")
      @assignment.truck.update!(status: "assigned")
      redirect_to driver_assignments_path, notice: "Driver assigned successfully."
    else
      redirect_to driver_assignments_path, alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @assignment = DriverAssignment.find(params[:id])
    authorize @assignment

    @assignment.update!(released_at: Time.current)
    unless @assignment.driver.driver_assignments.where(released_at: nil).exists?
      @assignment.driver.update!(status: "available")
    end
    redirect_to driver_assignments_path, notice: "Driver released successfully."
  end

  private

  def assignment_params
    params.require(:driver_assignment).permit(:driver_id, :truck_id, :notes)
  end
end
