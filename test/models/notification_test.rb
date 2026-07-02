require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "factory is valid" do
    record = create(:notification)
    assert record.valid?
  end

  test "factory traits are valid" do
    assert create(:notification, :read).valid?
    assert create(:notification, :unread).valid?
    assert create(:notification, :with_notifiable).valid?
  end

  test "required validations" do
    record = build(:notification, type: nil)
    assert_not record.valid?
    assert_includes record.errors[:type], "can't be blank"

    record = build(:notification, title: nil)
    assert_not record.valid?
    assert_includes record.errors[:title], "can't be blank"
  end

  test "belongs_to user" do
    user = create(:user)
    notification = create(:notification, user: user)
    assert_equal user, notification.user
  end

  test "belongs_to notifiable polymorphic is optional" do
    notification = create(:notification, notifiable: nil)
    assert notification.valid?
  end

  test "belongs_to notifiable polymorphic" do
    shipment = create(:shipment)
    notification = create(:notification, :with_notifiable, notifiable: shipment)
    assert_equal shipment, notification.notifiable
  end

  test "scope unread returns unread notifications" do
    unread = create(:notification, read: false)
    create(:notification, :read)
    assert_includes Notification.unread, unread
    assert_equal 1, Notification.unread.count
  end

  test "mark_as_read! updates read and read_at" do
    notification = create(:notification, read: false, read_at: nil)
    freeze_time do
      notification.mark_as_read!
      assert notification.read
      assert_equal Time.current, notification.read_at
    end
  end

  test "default read is false" do
    notification = create(:notification)
    assert_not notification.read
    assert_nil notification.read_at
  end

  test "is destroyed when user is destroyed" do
    notification = create(:notification)
    notification.user.destroy
    assert_raises(ActiveRecord::RecordNotFound) { notification.reload }
  end

  test "is destroyed when notifiable is destroyed" do
    notification = create(:notification, :with_notifiable)
    notifiable = notification.notifiable
    notifiable.destroy
    assert_raises(ActiveRecord::RecordNotFound) { notification.reload }
  end
end
