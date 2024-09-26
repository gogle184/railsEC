class ProductsController < ApplicationController

  def index
    @products = Product.displayed.order_by_position
  end

  def show
    @product = Product.find(params[:id])
  end
end
