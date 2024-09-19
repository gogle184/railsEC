# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    admins_products_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
