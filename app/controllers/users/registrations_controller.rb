class Users::RegistrationsController < Devise::RegistrationsController
  SIGNUP_ROLES = %w[user admin].freeze

  def create
    build_resource(sign_up_params)
    unless allowed_signup_role?
      resource.errors.add(:role_id, :not_allowed)
      clean_up_passwords resource
      set_minimum_password_length
      return respond_with resource
    end
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id)
  end

  def build_resource(hash = {})
    super.tap { |res| res.status = "onboarding" }
  end

  def allowed_signup_role?
    Role.where(name: SIGNUP_ROLES).pluck(:id).include?(resource.role_id)
  end
end
