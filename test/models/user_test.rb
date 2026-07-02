require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:user)
    assert record.valid?
  end

  test "factory traits are valid" do
    assert create(:user, :super_admin).valid?
    assert create(:user, :admin).valid?
    assert create(:user, :dispatcher).valid?
    assert create(:user, :operator).valid?
    assert create(:user, :account).valid?
    assert create(:user, :viewer).valid?
  end

  test "required validations" do
    record = build(:user, name: nil)
    assert_not record.valid?
    assert_includes record.errors[:name], "can't be blank"
  end

  test "status inclusion" do
    assert build(:user, status: "active").valid?
    assert build(:user, status: "inactive").valid?
    record = build(:user, status: "invalid_status")
    assert_not record.valid?
    assert_includes record.errors[:status], "is not included in the list"
  end

  test "belongs_to role" do
    role = create(:role)
    user = create(:user, role: role)
    assert_equal role, user.role
  end

  test "has_many shipments" do
    user = create(:user)
    shipment = create(:shipment, created_by: user)
    assert_includes user.shipments, shipment
  end

  test "has_many assigned_assignments" do
    user = create(:user)
    assignment = create(:driver_assignment, assigned_by: user)
    assert_includes user.assigned_assignments, assignment
  end

  test "has_many status_logs" do
    user = create(:user)
    log = create(:shipment_status_log, changed_by: user)
    assert_includes user.status_logs, log
  end

  test "has_many location_logs" do
    user = create(:user)
    log = create(:truck_location_log, updated_by: user)
    assert_includes user.location_logs, log
  end

  test "has_many notifications" do
    user = create(:user)
    notification = create(:notification, user: user)
    assert_includes user.notifications, notification
  end

  test "has_many audit_logs" do
    user = create(:user)
    log = create(:audit_log, user: user)
    assert_includes user.audit_logs, log
  end

  test "devise modules are present" do
    user = create(:user, email: "test@example.com", password: "password123")
    assert user.valid_password?("password123")
    assert_not user.valid_password?("wrong")
  end

  test "admin? returns true for super_admin and admin roles" do
    super_admin = create(:user, :super_admin)
    admin = create(:user, :admin)
    viewer = create(:user, :viewer)
    assert super_admin.admin?
    assert admin.admin?
    assert_not viewer.admin?
  end

  test "super_admin? returns true only for super_admin role" do
    super_admin = create(:user, :super_admin)
    admin = create(:user, :admin)
    assert super_admin.super_admin?
    assert_not admin.super_admin?
  end

  test "display_name returns name when present" do
    user = create(:user, name: "John Doe")
    assert_equal "John Doe", user.display_name
  end
end
