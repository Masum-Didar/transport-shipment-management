class AuditLogPolicy < ApplicationPolicy
  def index? = user.role.name.in?(%w[super_admin admin])
end
