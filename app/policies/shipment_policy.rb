class ShipmentPolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin dispatcher operator viewer account])
  def show?     = user.role.name.in?(%w[super_admin admin dispatcher operator viewer account])
  def create?   = user.role.name.in?(%w[super_admin admin dispatcher operator])
  def new?      = create?
  def update?   = user.role.name.in?(%w[super_admin admin dispatcher operator])
  def edit?     = update?
  def destroy?  = user.role.name.in?(%w[super_admin admin])

  def update_status?
    user.role.name.in?(%w[super_admin admin dispatcher operator])
  end
end
