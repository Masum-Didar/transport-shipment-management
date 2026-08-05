require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_role = Role.find_or_create_by!(name: "user")
    @admin_role = Role.find_or_create_by!(name: "admin")
    @super_admin_role = Role.find_or_create_by!(name: "super_admin")
  end

  test "signs up with the user role" do
    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: { name: "New User", email: "newuser@example.com", password: "password123", password_confirmation: "password123", role_id: @user_role.id }
      }
    end

    user = User.find_by(email: "newuser@example.com")
    assert_equal @user_role, user.role
    assert_equal "onboarding", user.status
    assert_redirected_to root_path
  end

  test "signs up with the admin role" do
    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: { name: "New Admin", email: "newadmin@example.com", password: "password123", password_confirmation: "password123", role_id: @admin_role.id }
      }
    end

    user = User.find_by(email: "newadmin@example.com")
    assert_equal @admin_role, user.role
    assert_equal "onboarding", user.status
  end

  test "rejects super_admin role on signup" do
    assert_no_difference "User.count" do
      post user_registration_path, params: {
        user: { name: "Sneaky Admin", email: "sneaky@example.com", password: "password123", password_confirmation: "password123", role_id: @super_admin_role.id }
      }
    end

    assert_response :unprocessable_entity
    assert_match "not available for signup", response.body
  end

  test "requires a role on signup" do
    assert_no_difference "User.count" do
      post user_registration_path, params: {
        user: { name: "No Role", email: "norole@example.com", password: "password123", password_confirmation: "password123", role_id: nil }
      }
    end

    assert_response :unprocessable_entity
  end
end
