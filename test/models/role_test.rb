require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:role)
    assert record.valid?
  end

  test "factory traits are valid" do
    assert create(:role, :super_admin).valid?
    assert create(:role, :admin).valid?
    assert create(:role, :dispatcher).valid?
    assert create(:role, :operator).valid?
    assert create(:role, :account).valid?
  end

  test "required validations" do
    record = build(:role, name: nil)
    assert_not record.valid?
    assert_includes record.errors[:name], "can't be blank"
  end

  test "uniqueness of name" do
    create(:role, name: "viewer")
    record = build(:role, name: "viewer")
    assert_not record.valid?
    assert_includes record.errors[:name], "has already been taken"
  end

  test "has_many users" do
    role = create(:role)
    user1 = create(:user, role: role)
    user2 = create(:user, role: role)
    assert_equal [user1, user2], role.users
  end

  test "dependent restrict_with_error on users" do
    role = create(:role)
    create(:user, role: role)
    assert_not role.destroy
    assert_includes role.errors[:base], "Cannot delete record because dependent users exist"
  end
end
