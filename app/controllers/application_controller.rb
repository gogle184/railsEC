class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_cart

  private

  def current_cart
    if user_signed_in?
      current_cart = current_user.cart || current_user.create_cart!
      if session[:cart_id]
        guest_cart = Cart.find_by(id: session[:cart_id])
        if guest_cart.present?
          current_cart.combine_and_destroy_other_cart!(guest_cart)
          session.delete(:cart_id)
        end
      end
    else
      current_cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] ||= current_cart.id
    end
    current_cart
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[display_name name phone_number postal_code address])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[display_name name phone_number postal_code address])
  end
end
