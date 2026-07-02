require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:product)
    assert record.valid?
  end

  test "required validations" do
    record = build(:product, name: nil)
    assert_not record.valid?
    assert_includes record.errors[:name], "can't be blank"

    record = build(:product, default_unit: nil)
    assert_not record.valid?
    assert_includes record.errors[:default_unit], "can't be blank"
  end

  test "belongs_to product_category is optional" do
    product = create(:product, product_category: nil)
    assert product.valid?
  end

  test "belongs_to product_category" do
    category = create(:product_category)
    product = create(:product, product_category: category)
    assert_equal category, product.product_category
  end

  test "has_many shipment_items" do
    product = create(:product)
    item = create(:shipment_item, product: product)
    assert_includes product.shipment_items, item
  end

  test "scope active returns kept records" do
    product = create(:product)
    create(:product).discard
    assert_includes Product.active, product
  end

  test "display_name returns name" do
    product = create(:product, name: "Cement")
    assert_equal "Cement", product.display_name
  end

  test "discard works" do
    product = create(:product)
    product.discard
    assert product.discarded?
  end
end
