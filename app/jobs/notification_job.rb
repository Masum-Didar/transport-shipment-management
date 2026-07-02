class NotificationJob < ApplicationJob
  queue_as :notifications

  def perform(type:, title:, message:, user_id:, notifiable_type: nil, notifiable_id: nil)
    Notification.create!(
      user_id: user_id,
      type: type,
      title: title,
      message: message,
      notifiable_type: notifiable_type,
      notifiable_id: notifiable_id
    )
  end
end
