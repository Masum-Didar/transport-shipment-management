require "test_helper"

class DriverAssignmentTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:driver_assignment)
    assert record.valid?
  end

  test "factory trait released is valid" do
    assert create(:driver_assignment, :released).valid?
  end

  test "required validations" do
    record = build(:driver_assignment, assigned_at: nil)
    assert_not record.valid?
    assert_includes record.errors[:assigned_at], "can't be blank"
  end

  test "belongs_to driver" do
    driver = create(:driver)
    assignment = create(:driver_assignment, driver: driver)
    assert_equal driver, assignment.driver
  end

  test "belongs_to truck" do
    truck = create(:truck)
    assignment = create(:driver_assignment, truck: truck)
    assert_equal truck, assignment.truck
  end

  test "belongs_to assigned_by" do
    user = create(:user)
    assignment = create(:driver_assignment, assigned_by: user)
    assert_equal user, assignment.assigned_by
  end

  test "scope current returns unreleased assignments" do
    current = create(:driver_assignment, released_at: nil)
    create(:driver_assignment, :released)
    assert_includes DriverAssignment.current, current
    assert_equal 1, DriverAssignment.current.count
  end

  test "scope completed returns released assignments" do
    create(:driver_assignment, released_at: nil)
    completed = create(:driver_assignment, :released)
    assert_includes DriverAssignment.completed, completed
    assert_equal 1, DriverAssignment.completed.count
  end

  test "duration returns hours between assigned_at and released_at" do
    assigned_at = 5.hours.ago
    released_at = Time.current
    assignment = create(:driver_assignment, assigned_at: assigned_at, released_at: released_at)
    assert_equal 5, assignment.duration
  end

  test "duration returns nil when not released" do
    assignment = create(:driver_assignment, released_at: nil)
    assert_nil assignment.duration
  end
end
