class ReportPolicy < ApplicationPolicy
  def index? = user.role.name.in?(%w[super_admin admin dispatcher account viewer])
end
