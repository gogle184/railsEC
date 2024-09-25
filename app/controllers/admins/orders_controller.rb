class Admins::OrdersController < ApplicationController
  before_action :set_order, only: %i[show update]

  def index
    @orders = Order.order_by_newest
  end

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to admins_order_path(@order), notice: t('common.controller.order.update.success')
    else
      flash.now[:alert] = t('common.controller.order.update.failed')
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
