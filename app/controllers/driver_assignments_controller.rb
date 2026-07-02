class DriverAssignmentsController < AuthenticatedController
  def index
    @assignments = policy_scope(DriverAssignment).includes(:driver, :truck, :assigned_by)
                        .order(assigned_at: :desc)
  end

  def create
    @assignment = DriverAssignment.new(assignment_params)
    @assignment.assigned_by = current_user
    @assignment.assigned_at = Time.current
    authorize @assignment

    if @assignment.save
      @assignment.driver.update!(status: "driving")
      @assignment.truck.update!(status: "assigned")
      redirect_back fallback_location: drivers_path, notice: "Driver assigned successfully."
    else
      redirect_back fallback_location: drivers_path, alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @assignment = DriverAssignment.find(params[:id])
    authorize @assignment

    @assignment.update!(released_at: Time.current)
    @assignment.driver.update!(status: "available") unless @assignment.driver.driver_assignments.where(released_at: nil).exists?
    redirect_back fallback_location: drivers_path, notice: "Driver released successfully."
  end

  private

  def assignment_params
    params.require(:driver_assignment).permit(:driver_id, :truck_id, :notes)
  end
end
