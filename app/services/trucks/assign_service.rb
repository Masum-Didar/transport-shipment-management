module Trucks
  class AssignService
    def initialize(truck, driver, assigned_by, notes: nil)
      @truck = truck
      @driver = driver
      @assigned_by = assigned_by
      @notes = notes
    end

    def call
      DriverAssignment.transaction do
        release_current_driver if @truck.current_driver

        assignment = DriverAssignment.create!(
          driver: @driver,
          truck: @truck,
          assigned_by: @assigned_by,
          assigned_at: Time.current,
          notes: @notes
        )

        @driver.update!(status: "driving")
        @truck.update!(status: "assigned")

        DriverNotificationJob.perform_later(driver_assignment_id: assignment.id, event: "assigned")

        assignment
      end
    end

    private

    def release_current_driver
      current = @truck.driver_assignments.current.last
      return unless current

      current.update!(released_at: Time.current)
      current.driver.update!(status: "available")
      DriverNotificationJob.perform_later(driver_assignment_id: current.id, event: "released")
    end
  end
end
