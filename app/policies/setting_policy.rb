class SettingPolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin])
  def update?   = user.role.name.in?(%w[super_admin admin])
end
