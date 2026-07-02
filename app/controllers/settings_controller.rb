class SettingsController < ApplicationController
  def index
    @settings = policy_scope(Setting).order(:group, :key)
    @groups = @settings.pluck(:group).uniq
  end

  def update
    @setting = Setting.find(params[:id])
    authorize @setting
    if @setting.update(value: params[:setting][:value])
      redirect_to settings_path, notice: "Setting updated successfully."
    else
      redirect_to settings_path, alert: "Failed to update setting."
    end
  end
end
