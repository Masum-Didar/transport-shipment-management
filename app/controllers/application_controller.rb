class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_locale

  private

  def set_locale
    locale = params[:locale] || session[:locale] || I18n.default_locale
    if I18n.available_locales.map(&:to_s).include?(locale.to_s)
      I18n.locale = locale.to_sym
      session[:locale] = I18n.locale
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
