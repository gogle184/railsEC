class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[display_name name phone_number postal_code address])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[display_name name phone_number postal_code address])
  end
end
