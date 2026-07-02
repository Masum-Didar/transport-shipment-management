require "test_helper"

class RouteTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:route)
    assert record.valid?
  end

  test "required validations" do
    loc = create(:location)

    record = build(:route, from_location: nil, to_location: loc)
    assert_not record.valid?
    assert_includes record.errors[:from_location_id], "can't be blank"

    record = build(:route, from_location: loc, to_location: nil)
    assert_not record.valid?
    assert_includes record.errors[:to_location_id], "can't be blank"
  end

  test "custom validation different_locations" do
    location = create(:location)
    record = Route.new(from_location_id: location.id, to_location_id: location.id)
    assert_not record.valid?
    assert_includes record.errors[:to_location_id], "cannot be the same as source location"
  end

  test "belongs_to from_location" do
    location = create(:location)
    route = create(:route, from_location: location)
    assert_equal location, route.from_location
  end

  test "belongs_to to_location" do
    location = create(:location)
    route = create(:route, to_location: location)
    assert_equal location, route.to_location
  end

  test "has_many shipments" do
    route = create(:route)
    shipment = create(:shipment, route: route)
    assert_includes route.shipments, shipment
  end

  test "scope active returns kept records" do
    route = create(:route)
    create(:route).discard
    assert_includes Route.active, route
  end

  test "display_name formats with arrow" do
    from = create(:location, name: "Chittagong")
    to = create(:location, name: "Dhaka")
    route = create(:route, from_location: from, to_location: to)
    assert_equal "Chittagong \342\206\222 Dhaka", route.display_name
  end

  test "discard works" do
    route = create(:route)
    route.discard
    assert route.discarded?
  end
end
