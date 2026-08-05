class LocationPolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin dispatcher user viewer])
  def create?   = user.role.name.in?(%w[super_admin admin dispatcher user])
  def new?      = create?
  def update?   = user.role.name.in?(%w[super_admin admin dispatcher user])
  def edit?     = update?
  def destroy?  = user.role.name.in?(%w[super_admin admin])
end
