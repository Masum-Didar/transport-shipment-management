class ShipmentPolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin dispatcher operator user viewer account])
  def show?     = user.role.name.in?(%w[super_admin admin dispatcher operator user viewer account])
  def create?   = user.role.name.in?(%w[super_admin admin dispatcher operator user])
  def new?      = create?
  def update?   = user.role.name.in?(%w[super_admin admin dispatcher operator user])
  def edit?     = update?
  def destroy?  = user.role.name.in?(%w[super_admin admin])

  def update_status?
    user.role.name.in?(%w[super_admin admin dispatcher operator user])
  end
end
