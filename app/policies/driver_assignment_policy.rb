class DriverAssignmentPolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin dispatcher operator viewer])
  def create?   = user.role.name.in?(%w[super_admin admin dispatcher])
  def destroy?  = user.role.name.in?(%w[super_admin admin dispatcher])
end
