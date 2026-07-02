require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:location)
    assert record.valid?
  end

  test "factory traits are valid" do
    assert create(:location, :port).valid?
    assert create(:location, :warehouse).valid?
    assert create(:location, :factory).valid?
  end

  test "required validations" do
    record = build(:location, name: nil)
    assert_not record.valid?
    assert_includes record.errors[:name], "can't be blank"
  end

  test "location_type inclusion" do
    %w[port icd warehouse factory border other].each do |t|
      assert build(:location, location_type: t).valid?, "#{t} should be valid"
    end
    record = build(:location, location_type: "invalid_type")
    assert_not record.valid?
    assert_includes record.errors[:location_type], "is not included in the list"
  end

  test "has_many routes_from" do
    location = create(:location)
    route = create(:route, from_location: location)
    assert_includes location.routes_from, route
  end

  test "has_many routes_to" do
    location = create(:location)
    route = create(:route, to_location: location)
    assert_includes location.routes_to, route
  end

  test "has_many source_shipments" do
    location = create(:location)
    shipment = create(:shipment, source_location: location)
    assert_includes location.source_shipments, shipment
  end

  test "has_many destination_shipments" do
    location = create(:location)
    shipment = create(:shipment, destination_location: location)
    assert_includes location.destination_shipments, shipment
  end

  test "has_many trucks_at_location" do
    location = create(:location)
    truck = create(:truck, current_location: location)
    assert_includes location.trucks_at_location, truck
  end

  test "scope active returns kept records" do
    location = create(:location)
    create(:location).discard
    assert_includes Location.active, location
  end

  test "scope by_type filters by location_type" do
    port = create(:location, :port)
    create(:location, :warehouse)
    assert_includes Location.by_type("port"), port
    assert_equal 1, Location.by_type("port").count
  end

  test "discard works" do
    location = create(:location)
    location.discard
    assert location.discarded?
  end
end
