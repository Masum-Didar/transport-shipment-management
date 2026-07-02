class AuditLogsController < AuthenticatedController
  def index
    @logs = policy_scope(AuditLog).includes(:user).recent.limit(100)
  end
end
