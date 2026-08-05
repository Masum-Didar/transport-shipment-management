class UsersController < AuthenticatedController
  before_action :set_user, only: %i[activate deactivate]

  def index
    authorize User, :index?
    @users = policy_scope(User).kept.order(created_at: :desc)
    @users = @users.ransack(name_or_email_cont: params[:q]).result if params[:q].present?
    @users = @users.where(status: params[:status]) if params[:status].present?
  end

  def activate
    if @user.update(status: "active")
      redirect_to users_path, notice: t("flash.user_activated", name: @user.name)
    else
      redirect_to users_path, alert: t("flash.user_activation_failed")
    end
  end

  def deactivate
    if @user.update(status: "inactive")
      redirect_to users_path, notice: t("flash.user_deactivated", name: @user.name)
    else
      redirect_to users_path, alert: t("flash.user_deactivation_failed")
    end
  end

  private

  def set_user
    @user = policy_scope(User).kept.find(params[:id])
    authorize @user
  end
end
