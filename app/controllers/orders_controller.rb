class OrdersController < ApplicationController
  before_action :authenticate_user!

  def confirm
    @order = current_user.orders.build
    @order.build_with_cart_items(current_cart.cart_items)
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.build_with_cart_items(current_cart.cart_items)

    if @order.save
      current_cart.destroy!
      UserMailer.order_accepted(@order).deliver_later
      redirect_to root_path, notice: t('common.controller.order.success')
    else
      flash.now[:alert] = t('common.view.controller.order.failed')
      render :confirm
    end
  end

  private

  def order_params
    params.require(:order).permit(:schedule_date, :schedule_time, :shipping_fee, :cash_on_delivery)
  end
end
