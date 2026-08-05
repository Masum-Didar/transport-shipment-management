require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_role = Role.find_or_create_by!(name: "admin")
    @super_admin_role = Role.find_or_create_by!(name: "super_admin")
    @user_role = Role.find_or_create_by!(name: "user")

    @super_admin = create(:user, role: @super_admin_role, email: "super-admin-#{SecureRandom.hex(4)}@example.com")
    @admin = create(:user, role: @admin_role, email: "admin-#{SecureRandom.hex(4)}@example.com")
  end

  test "admin can list all accounts" do
    @pending_user = create(:user, role: @user_role, status: "onboarding", email: "pending-#{SecureRandom.hex(4)}@example.com")

    sign_in @admin
    get users_path
    assert_response :success
    assert_includes response.body, @pending_user.email
    assert_includes response.body, @admin.email
    assert_includes response.body, @super_admin.email
  end

  test "list shows the role column" do
    sign_in @admin
    get users_path
    assert_response :success
    assert_includes response.body, "Role"
  end

  test "super admin can list all accounts" do
    @pending_user = create(:user, role: @user_role, status: "onboarding", email: "pending-#{SecureRandom.hex(4)}@example.com")

    sign_in @super_admin
    get users_path
    assert_response :success
    assert_includes response.body, @pending_user.email
    assert_includes response.body, @admin.email
  end

  test "non-admin user cannot access users index" do
    @viewer_role = Role.find_or_create_by!(name: "viewer")
    @viewer = create(:user, role: @viewer_role, email: "viewer-#{SecureRandom.hex(4)}@example.com")
    sign_in @viewer
    get users_path
    assert_redirected_to root_path
  end

  test "admin can activate an onboarding user" do
    @pending_user = create(:user, role: @user_role, status: "onboarding", email: "activate-#{SecureRandom.hex(4)}@example.com")

    sign_in @admin
    patch activate_user_path(@pending_user, locale: I18n.locale)
    assert_redirected_to users_path
    assert_equal "active", @pending_user.reload.status
  end

  test "admin can see but cannot activate an admin account" do
    @pending_admin = create(:user, role: @admin_role, status: "onboarding", email: "pending-admin-#{SecureRandom.hex(4)}@example.com")

    sign_in @admin
    get users_path
    assert_includes response.body, @pending_admin.email

    patch activate_user_path(@pending_admin, locale: I18n.locale)
    assert_redirected_to root_path
    assert_equal "onboarding", @pending_admin.reload.status
  end

  test "admin cannot activate a super admin account" do
    @pending_super = create(:user, role: @super_admin_role, status: "onboarding", email: "pending-super-#{SecureRandom.hex(4)}@example.com")

    sign_in @admin
    patch activate_user_path(@pending_super, locale: I18n.locale)
    assert_redirected_to root_path
    assert_equal "onboarding", @pending_super.reload.status
  end

  test "super admin can activate an onboarding admin" do
    @pending_admin = create(:user, role: @admin_role, status: "onboarding", email: "pending-admin-#{SecureRandom.hex(4)}@example.com")

    sign_in @super_admin
    patch activate_user_path(@pending_admin, locale: I18n.locale)
    assert_redirected_to users_path
    assert_equal "active", @pending_admin.reload.status
  end

  test "super admin cannot activate another super admin" do
    @other_super = create(:user, role: @super_admin_role, status: "onboarding", email: "other-super-#{SecureRandom.hex(4)}@example.com")

    sign_in @super_admin
    patch activate_user_path(@other_super, locale: I18n.locale)
    assert_redirected_to root_path
    assert_equal "onboarding", @other_super.reload.status
  end

  test "admin can deactivate an active user" do
    @active_user = create(:user, role: @user_role, status: "active", email: "deactivate-#{SecureRandom.hex(4)}@example.com")

    sign_in @admin
    patch deactivate_user_path(@active_user, locale: I18n.locale)
    assert_redirected_to users_path
    assert_equal "inactive", @active_user.reload.status
  end
end
