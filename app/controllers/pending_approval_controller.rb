class PendingApprovalController < AuthenticatedController
  layout "pending_approval"

  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def show
  end
end
