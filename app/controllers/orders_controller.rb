class OrdersController < ApplicationController
  before_action :authenticate_user!

  def confirm
    @order = current_user.orders.build_with_order_items(cart_items: current_cart.cart_items)
  end

  def create
    @order = current_user.orders.build_with_order_items(order_params)
    if @order.save
      current_cart.destroy!
      redirect_to root_path, notice: '注文を承りました'
    else
      render :confirm
    end
  end

  private

  # def order_params
  #   params.require(:order).permit(:cart_items_attributes: %i[product_id quantity], :schedule_date, :schedule_time)
  # end
end
