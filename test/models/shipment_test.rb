require "test_helper"

class ShipmentTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:shipment)
    assert record.valid?
  end

  test "factory traits are valid" do
    assert create(:shipment, :import).valid?
    assert create(:shipment, :export).valid?
    assert create(:shipment, :loading).valid?
    assert create(:shipment, :loaded).valid?
    assert create(:shipment, :on_the_way).valid?
    assert create(:shipment, :reached).valid?
    assert create(:shipment, :unloading).valid?
    assert create(:shipment, :completed).valid?
    assert create(:shipment, :with_items).valid?
  end

  test "required validations" do
    record = build(:shipment, shipment_number: nil)
    assert_not record.valid?
    assert_includes record.errors[:shipment_number], "can't be blank"
  end

  test "uniqueness of shipment_number" do
    create(:shipment, shipment_number: "SH-001")
    record = build(:shipment, shipment_number: "SH-001")
    assert_not record.valid?
    assert_includes record.errors[:shipment_number], "has already been taken"
  end

  test "shipment_type inclusion" do
    %w[import export].each do |t|
      assert build(:shipment, shipment_type: t).valid?, "#{t} should be valid"
    end
    record = build(:shipment, shipment_type: "invalid_type")
    assert_not record.valid?
    assert_includes record.errors[:shipment_type], "is not included in the list"
  end

  test "status inclusion" do
    %w[pending loading loaded on_the_way reached unloading completed].each do |s|
      assert build(:shipment, status: s).valid?, "#{s} should be valid"
    end
    record = build(:shipment, status: "invalid_status")
    assert_not record.valid?
    assert_includes record.errors[:status], "is not included in the list"
  end

  test "shipment_date presence" do
    record = build(:shipment, shipment_date: nil)
    assert_not record.valid?
    assert_includes record.errors[:shipment_date], "can't be blank"
  end

  test "belongs_to source_location is optional" do
    shipment = create(:shipment, source_location: nil)
    assert shipment.valid?
  end

  test "belongs_to destination_location is optional" do
    shipment = create(:shipment, destination_location: nil)
    assert shipment.valid?
  end

  test "belongs_to route is optional" do
    shipment = create(:shipment, route: nil)
    assert shipment.valid?
  end

  test "belongs_to truck is optional" do
    shipment = create(:shipment, truck: nil)
    assert shipment.valid?
  end

  test "belongs_to created_by" do
    user = create(:user)
    shipment = create(:shipment, created_by: user)
    assert_equal user, shipment.created_by
  end

  test "has_many shipment_items" do
    shipment = create(:shipment)
    item = create(:shipment_item, shipment: shipment)
    assert_includes shipment.shipment_items, item
  end

  test "has_many products through shipment_items" do
    shipment = create(:shipment)
    product = create(:product)
    create(:shipment_item, shipment: shipment, product: product)
    assert_includes shipment.products, product
  end

  test "accepts_nested_attributes_for shipment_items" do
    product = create(:product)
    shipment = create(:shipment, shipment_items_attributes: [
      { product_id: product.id, quantity: 100, unit: "kg" }
    ])
    assert_equal 1, shipment.shipment_items.count
    assert_equal 100, shipment.shipment_items.first.quantity
  end

  test "has_many status_logs" do
    shipment = create(:shipment)
    log = create(:shipment_status_log, shipment: shipment)
    assert_includes shipment.status_logs, log
  end

  test "has_many notifications as notifiable" do
    shipment = create(:shipment)
    notification = create(:notification, notifiable: shipment)
    assert_includes shipment.notifications, notification
  end

  test "scope active returns kept records" do
    shipment = create(:shipment)
    create(:shipment).discard
    assert_includes Shipment.active, shipment
  end

  test "scope imports returns only import shipments" do
    import = create(:shipment, :import)
    create(:shipment, :export)
    assert_includes Shipment.imports, import
    assert_equal 1, Shipment.imports.count
  end

  test "scope exports returns only export shipments" do
    export = create(:shipment, :export)
    create(:shipment, :import)
    assert_includes Shipment.exports, export
    assert_equal 1, Shipment.exports.count
  end

  test "scope by_status filters by status" do
    pending = create(:shipment, status: "pending")
    create(:shipment, status: "loading")
    assert_includes Shipment.by_status("pending"), pending
    assert_equal 1, Shipment.by_status("pending").count
  end

  test "scope today returns today's shipments" do
    today_shipment = create(:shipment, shipment_date: Date.current)
    create(:shipment, shipment_date: Date.yesterday)
    assert_includes Shipment.today, today_shipment
  end

  test "scope this_week returns this week's shipments" do
    this_week = create(:shipment, shipment_date: Date.current)
    assert_includes Shipment.this_week, this_week
  end

  test "scope this_month returns this month's shipments" do
    this_month = create(:shipment, shipment_date: Date.current)
    assert_includes Shipment.this_month, this_month
  end

  test "display_name returns shipment_number" do
    shipment = create(:shipment, shipment_number: "SH-001")
    assert_equal "SH-001", shipment.display_name
  end

  test "total_weight sums shipment_items weight" do
    shipment = create(:shipment)
    create(:shipment_item, shipment: shipment, weight: 100)
    create(:shipment_item, shipment: shipment, weight: 200)
    assert_equal 300, shipment.total_weight
  end

  test "total_quantity sums shipment_items quantity" do
    shipment = create(:shipment)
    create(:shipment_item, shipment: shipment, quantity: 50)
    create(:shipment_item, shipment: shipment, quantity: 150)
    assert_equal 200, shipment.total_quantity
  end

  test "update_status transitions correctly and creates log" do
    user = create(:user)
    shipment = create(:shipment, status: "pending")
    assert shipment.update_status("loading", user: user)
    assert_equal "loading", shipment.reload.status
    assert_equal 1, shipment.status_logs.count
    assert_equal user, shipment.status_logs.last.changed_by
  end

  test "update_status rejects invalid transitions" do
    user = create(:user)
    shipment = create(:shipment, status: "pending")
    assert_not shipment.update_status("completed", user: user)
    assert_equal "pending", shipment.status
  end

  test "update_status sets actual_delivery_date on completion" do
    user = create(:user)
    shipment = create(:shipment, status: "unloading")
    freeze_time do
      shipment.update_status("completed", user: user)
      assert_equal Date.current, shipment.reload.actual_delivery_date
    end
  end
end
