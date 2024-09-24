class Admins::OrdersController < ApplicationController
  def index
    @orders = Order.order_by_newest
  end

  def show
    @order = Order.find(params[:id])
  end
end
