require "test_helper"

class TruckLocationLogTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:truck_location_log)
    assert record.valid?
  end

  test "required validations" do
    record = build(:truck_location_log, location: nil)
    assert_not record.valid?
    assert_includes record.errors[:location], "can't be blank"

    record = build(:truck_location_log, logged_at: nil)
    assert_not record.valid?
    assert_includes record.errors[:logged_at], "can't be blank"
  end

  test "belongs_to truck" do
    truck = create(:truck)
    log = create(:truck_location_log, truck: truck)
    assert_equal truck, log.truck
  end

  test "belongs_to updated_by is optional" do
    log = create(:truck_location_log, updated_by: nil)
    assert log.valid?
  end

  test "belongs_to updated_by" do
    user = create(:user)
    log = create(:truck_location_log, updated_by: user)
    assert_equal user, log.updated_by
  end

  test "is destroyed when truck is destroyed" do
    log = create(:truck_location_log)
    log.truck.destroy
    assert_raises(ActiveRecord::RecordNotFound) { log.reload }
  end
end
