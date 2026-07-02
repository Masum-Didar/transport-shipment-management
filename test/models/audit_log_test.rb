require "test_helper"

class AuditLogTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:audit_log)
    assert record.valid?
  end

  test "required validations" do
    record = build(:audit_log, action: nil)
    assert_not record.valid?
    assert_includes record.errors[:action], "can't be blank"

    record = build(:audit_log, auditable_type: nil)
    assert_not record.valid?
    assert_includes record.errors[:auditable_type], "can't be blank"

    record = build(:audit_log, auditable_id: nil)
    assert_not record.valid?
    assert_includes record.errors[:auditable_id], "can't be blank"
  end

  test "belongs_to user is optional" do
    log = create(:audit_log, user: nil)
    assert log.valid?
  end

  test "belongs_to user" do
    user = create(:user)
    log = create(:audit_log, user: user)
    assert_equal user, log.user
  end

  test "belongs_to auditable polymorphic" do
    truck = create(:truck)
    log = create(:audit_log, auditable: truck)
    assert_equal truck, log.auditable
  end

  test "scope recent orders by created_at descending" do
    log1 = create(:audit_log, created_at: 2.days.ago)
    log2 = create(:audit_log, created_at: 1.day.ago)
    log3 = create(:audit_log, created_at: Time.current)
    assert_equal [log3, log2, log1], AuditLog.recent.to_a
  end

  test "scope by_user filters by user" do
    user = create(:user)
    log = create(:audit_log, user: user)
    create(:audit_log)
    assert_includes AuditLog.by_user(user), log
    assert_equal 1, AuditLog.by_user(user).count
  end

  test "scope for_auditable filters by type and id" do
    truck = create(:truck)
    log = create(:audit_log, auditable: truck)
    create(:audit_log, auditable: create(:truck))
    assert_includes AuditLog.for_auditable("Truck", truck.id), log
    assert_equal 1, AuditLog.for_auditable("Truck", truck.id).count
  end

  test "audited_changes stores jsonb data" do
    changes = { "name" => [nil, "new_name"], "status" => ["active", "inactive"] }
    log = create(:audit_log, audited_changes: changes)
    assert_equal changes, log.audited_changes
  end

  test "is nullified when user is destroyed" do
    log = create(:audit_log)
    user = log.user
    user.destroy
    log.reload
    assert_nil log.user_id
  end
end
