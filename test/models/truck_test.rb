require "test_helper"

class TruckTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:truck)
    assert record.valid?
  end

  test "factory traits are valid" do
    assert create(:truck, :company).valid?
    assert create(:truck, :outside).valid?
    assert create(:truck, :assigned).valid?
    assert create(:truck, :maintenance).valid?
  end

  test "required validations" do
    record = build(:truck, truck_number: nil)
    assert_not record.valid?
    assert_includes record.errors[:truck_number], "can't be blank"
  end

  test "uniqueness of truck_number" do
    create(:truck, truck_number: "TRK001")
    record = build(:truck, truck_number: "TRK001")
    assert_not record.valid?
    assert_includes record.errors[:truck_number], "has already been taken"
  end

  test "truck_type inclusion" do
    assert build(:truck, :company).valid?
    assert build(:truck, :outside).valid?
    record = build(:truck, truck_type: "invalid_type")
    assert_not record.valid?
    assert_includes record.errors[:truck_type], "is not included in the list"
  end

  test "status inclusion" do
    %w[available assigned loading on_route maintenance inactive].each do |s|
      assert build(:truck, status: s).valid?, "#{s} should be valid"
    end
    record = build(:truck, status: "invalid_status")
    assert_not record.valid?
    assert_includes record.errors[:status], "is not included in the list"
  end

  test "belongs_to current_location is optional" do
    truck = create(:truck, current_location: nil)
    assert truck.valid?
  end

  test "belongs_to current_location" do
    location = create(:location)
    truck = create(:truck, current_location: location)
    assert_equal location, truck.current_location
  end

  test "has_many location_logs" do
    truck = create(:truck)
    log = create(:truck_location_log, truck: truck)
    assert_includes truck.location_logs, log
  end

  test "has_many driver_assignments" do
    truck = create(:truck)
    assignment = create(:driver_assignment, truck: truck)
    assert_includes truck.driver_assignments, assignment
  end

  test "has_many drivers through driver_assignments" do
    truck = create(:truck)
    driver = create(:driver)
    create(:driver_assignment, truck: truck, driver: driver)
    assert_includes truck.drivers, driver
  end

  test "has_many shipments" do
    truck = create(:truck)
    shipment = create(:shipment, truck: truck)
    assert_includes truck.shipments, shipment
  end

  test "scope active returns kept records" do
    truck = create(:truck)
    create(:truck).discard
    assert_includes Truck.active, truck
    assert_equal Truck.kept.count, Truck.active.count
  end

  test "scope available returns available trucks" do
    available = create(:truck, status: "available")
    create(:truck, status: "maintenance")
    assert_includes Truck.available, available
    assert_equal 1, Truck.available.count
  end

  test "scope by_type filters by truck_type" do
    company = create(:truck, :company)
    create(:truck, :outside)
    assert_includes Truck.by_type("company"), company
    assert_equal 1, Truck.by_type("company").count
  end

  test "current_driver returns active driver" do
    truck = create(:truck)
    driver = create(:driver)
    create(:driver_assignment, truck: truck, driver: driver, released_at: nil)
    assert_equal driver, truck.current_driver
  end

  test "current_driver returns nil when no active assignment" do
    truck = create(:truck)
    assert_nil truck.current_driver
  end

  test "current_shipment returns the latest non-completed shipment" do
    truck = create(:truck)
    shipment = create(:shipment, truck: truck, status: "loading")
    assert_equal shipment, truck.current_shipment
  end

  test "display_name formats correctly" do
    truck = create(:truck, truck_number: "TRK001", truck_type: "company")
    assert_equal "TRK001 (Company)", truck.display_name
  end
end
