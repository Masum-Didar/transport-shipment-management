class ProductCategoryPolicy < ApplicationPolicy
  def index?    = user.role.name.in?(%w[super_admin admin dispatcher operator user viewer])
  def create?   = user.role.name.in?(%w[super_admin admin dispatcher operator user])
  def new?      = create?
  def update?   = user.role.name.in?(%w[super_admin admin dispatcher operator user])
  def edit?     = update?
  def destroy?  = user.role.name.in?(%w[super_admin admin])
end
