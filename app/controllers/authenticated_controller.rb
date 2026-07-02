class AuthenticatedController < ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :set_current_attributes
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_current_attributes
    Current.user = current_user
    Current.ip_address = request.remote_ip
    Current.user_agent = request.user_agent
  end

  def user_not_authorized
    flash[:alert] = t("flash.not_authorized")
    redirect_back(fallback_location: root_path)
  end
end
