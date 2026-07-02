require "test_helper"

class DriverTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:driver)
    assert record.valid?
  end

  test "factory traits are valid" do
    assert create(:driver, :driving).valid?
    assert create(:driver, :leave).valid?
    assert create(:driver, :inactive).valid?
  end

  test "required validations" do
    record = build(:driver, name: nil)
    assert_not record.valid?
    assert_includes record.errors[:name], "can't be blank"

    record = build(:driver, phone: nil)
    assert_not record.valid?
    assert_includes record.errors[:phone], "can't be blank"
  end

  test "uniqueness of phone" do
    create(:driver, phone: "1234567890")
    record = build(:driver, phone: "1234567890")
    assert_not record.valid?
    assert_includes record.errors[:phone], "has already been taken"
  end

  test "status inclusion" do
    %w[available driving leave inactive].each do |s|
      assert build(:driver, status: s).valid?, "#{s} should be valid"
    end
    record = build(:driver, status: "invalid_status")
    assert_not record.valid?
    assert_includes record.errors[:status], "is not included in the list"
  end

  test "has_many driver_assignments" do
    driver = create(:driver)
    assignment = create(:driver_assignment, driver: driver)
    assert_includes driver.driver_assignments, assignment
  end

  test "has_many trucks through driver_assignments" do
    driver = create(:driver)
    truck = create(:truck)
    create(:driver_assignment, driver: driver, truck: truck)
    assert_includes driver.trucks, truck
  end

  test "discard works" do
    driver = create(:driver)
    driver.discard
    assert driver.discarded?
  end

  test "scope active returns kept records" do
    driver = create(:driver)
    create(:driver).discard
    assert_includes Driver.active, driver
  end

  test "scope available returns available drivers" do
    available = create(:driver, status: "available")
    create(:driver, status: "driving")
    assert_includes Driver.available, available
    assert_equal 1, Driver.available.count
  end

  test "current_truck returns the currently assigned truck" do
    driver = create(:driver)
    truck = create(:truck)
    create(:driver_assignment, driver: driver, truck: truck, released_at: nil)
    assert_equal truck, driver.current_truck
  end

  test "current_truck returns nil when not assigned" do
    driver = create(:driver)
    assert_nil driver.current_truck
  end

  test "currently_assigned? returns true when active assignment exists" do
    driver = create(:driver)
    create(:driver_assignment, driver: driver, released_at: nil)
    assert driver.currently_assigned?
  end

  test "currently_assigned? returns false when no active assignment" do
    driver = create(:driver)
    assert_not driver.currently_assigned?
  end

  test "display_name formats correctly" do
    driver = create(:driver, name: "John", phone: "1234567890")
    assert_equal "John (1234567890)", driver.display_name
  end
end
