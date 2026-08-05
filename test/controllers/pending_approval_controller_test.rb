require "test_helper"

class PendingApprovalControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_role = Role.find_or_create_by!(name: "user")
  end

  test "onboarding user is redirected to pending approval page" do
    @onboarding_user = create(:user, role: @user_role, status: "onboarding", email: "onboarding-#{SecureRandom.hex(4)}@example.com")

    sign_in @onboarding_user
    get root_path
    assert_redirected_to pending_approval_path
  end

  test "onboarding user can view pending approval page" do
    @onboarding_user = create(:user, role: @user_role, status: "onboarding", email: "pending-#{SecureRandom.hex(4)}@example.com")

    sign_in @onboarding_user
    get pending_approval_path
    assert_response :success
    assert_includes response.body, "Pending Approval"
  end

  test "pending approval page does not render the sidebar" do
    @onboarding_user = create(:user, role: @user_role, status: "onboarding", email: "sidebar-#{SecureRandom.hex(4)}@example.com")

    sign_in @onboarding_user
    get pending_approval_path
    assert_response :success
    assert_not_includes response.body, "data-sidebar-target"
    assert_not_includes response.body, "TSM System"
  end

  test "active user can access dashboard" do
    @active_user = create(:user, role: @user_role, status: "active", email: "active-#{SecureRandom.hex(4)}@example.com")

    sign_in @active_user
    get root_path
    assert_response :success
  end
end
