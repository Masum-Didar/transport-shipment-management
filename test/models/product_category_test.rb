require "test_helper"

class ProductCategoryTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:product_category)
    assert record.valid?
  end

  test "required validations" do
    record = build(:product_category, name: nil)
    assert_not record.valid?
    assert_includes record.errors[:name], "can't be blank"
  end

  test "uniqueness of name" do
    create(:product_category, name: "Electronics")
    record = build(:product_category, name: "Electronics")
    assert_not record.valid?
    assert_includes record.errors[:name], "has already been taken"
  end

  test "has_many products" do
    category = create(:product_category)
    product1 = create(:product, product_category: category)
    product2 = create(:product, product_category: category)
    assert_equal [product1, product2], category.products
  end

  test "dependent restrict_with_error on products" do
    category = create(:product_category)
    create(:product, product_category: category)
    assert_not category.destroy
    assert_includes category.errors[:base], "Cannot delete record because dependent products exist"
  end

  test "scope active returns kept records" do
    category = create(:product_category)
    create(:product_category).discard
    assert_includes ProductCategory.active, category
  end

  test "discard works" do
    category = create(:product_category)
    category.discard
    assert category.discarded?
  end
end
