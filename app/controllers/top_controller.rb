class TopController < ApplicationController
  def index
    @products = Product.displayed.order_by_position
  end
end
