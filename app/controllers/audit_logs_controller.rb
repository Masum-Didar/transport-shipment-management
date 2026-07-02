class AuditLogsController < ApplicationController
  def index
    @logs = policy_scope(AuditLog).includes(:user).recent.limit(100)
  end
end
