class NotificationsController < ApplicationController
  before_action :set_notification, only: :update

  def index
    @notifications = policy_scope(Notification).where(user: current_user).order(created_at: :desc).limit(50)
  end

  def update
    @notification.mark_as_read!
    redirect_to notifications_path
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read: true, read_at: Time.current)
    redirect_back fallback_location: notifications_path, notice: "All notifications marked as read."
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
    authorize @notification
  end
end
