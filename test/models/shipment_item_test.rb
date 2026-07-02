require "test_helper"

class ShipmentItemTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:shipment_item)
    assert record.valid?
  end

  test "required validations" do
    record = build(:shipment_item, quantity: nil)
    assert_not record.valid?
    assert_includes record.errors[:quantity], "can't be blank"
  end

  test "quantity numericality greater than 0" do
    record = build(:shipment_item, quantity: 0)
    assert_not record.valid?
    assert_includes record.errors[:quantity], "must be greater than 0"

    record = build(:shipment_item, quantity: -1)
    assert_not record.valid?
    assert_includes record.errors[:quantity], "must be greater than 0"
  end

  test "unit presence" do
    record = build(:shipment_item, unit: nil)
    assert_not record.valid?
    assert_includes record.errors[:unit], "can't be blank"
  end

  test "belongs_to shipment" do
    shipment = create(:shipment)
    item = create(:shipment_item, shipment: shipment)
    assert_equal shipment, item.shipment
  end

  test "belongs_to product" do
    product = create(:product)
    item = create(:shipment_item, product: product)
    assert_equal product, item.product
  end

  test "is destroyed when shipment is destroyed" do
    shipment = create(:shipment)
    item = create(:shipment_item, shipment: shipment)
    shipment.destroy
    assert_raises(ActiveRecord::RecordNotFound) { item.reload }
  end
end
