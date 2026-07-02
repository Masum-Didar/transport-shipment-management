class NotificationPolicy < ApplicationPolicy
  def index?         = true
  def update?        = true
  def mark_all_read? = true
end
