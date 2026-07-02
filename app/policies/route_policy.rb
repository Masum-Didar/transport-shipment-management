class RoutePolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin dispatcher viewer])
  def create?   = user.role.name.in?(%w[super_admin admin dispatcher])
  def new?      = create?
  def update?   = user.role.name.in?(%w[super_admin admin dispatcher])
  def edit?     = update?
  def destroy?  = user.role.name.in?(%w[super_admin admin])
end
