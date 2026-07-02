class DriverPolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin dispatcher operator viewer])
  def show?     = user.role.name.in?(%w[super_admin admin dispatcher operator viewer])
  def create?   = user.role.name.in?(%w[super_admin admin dispatcher operator])
  def new?      = create?
  def update?   = user.role.name.in?(%w[super_admin admin dispatcher operator])
  def edit?     = update?
  def destroy?  = user.role.name.in?(%w[super_admin admin])
end
