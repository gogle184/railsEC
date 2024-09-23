class CartsController < ApplicationController
  def show
    @cart_items = current_cart.cart_items.order_by_oldest
  end
end
