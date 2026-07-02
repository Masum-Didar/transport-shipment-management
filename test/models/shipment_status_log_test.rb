require "test_helper"

class ShipmentStatusLogTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:shipment_status_log)
    assert record.valid?
  end

  test "required validations" do
    record = build(:shipment_status_log, status: nil)
    assert_not record.valid?
    assert_includes record.errors[:status], "can't be blank"

    record = build(:shipment_status_log, changed_at: nil)
    assert_not record.valid?
    assert_includes record.errors[:changed_at], "can't be blank"
  end

  test "belongs_to shipment" do
    shipment = create(:shipment)
    log = create(:shipment_status_log, shipment: shipment)
    assert_equal shipment, log.shipment
  end

  test "belongs_to changed_by" do
    user = create(:user)
    log = create(:shipment_status_log, changed_by: user)
    assert_equal user, log.changed_by
  end

  test "scope chronological orders by changed_at ascending" do
    shipment = create(:shipment)
    log1 = create(:shipment_status_log, shipment: shipment, changed_at: 2.hours.ago)
    log2 = create(:shipment_status_log, shipment: shipment, changed_at: 1.hour.ago)
    log3 = create(:shipment_status_log, shipment: shipment, changed_at: Time.current)
    assert_equal [log1, log2, log3], shipment.status_logs.chronological
  end

  test "is destroyed when shipment is destroyed" do
    log = create(:shipment_status_log)
    log.shipment.destroy
    assert_raises(ActiveRecord::RecordNotFound) { log.reload }
  end
end
