class UserPolicy < ApplicationPolicy
  def index?
    user.role.name.in?(%w[super_admin admin])
  end

  def activate?
    return false if record.super_admin?

    if user.super_admin?
      true
    else
      record.role.name != "admin"
    end
  end
  alias deactivate? activate?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
