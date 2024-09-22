class Cart::CartItemsController < ApplicationController
  def create
    product = Product.find(params[:cart_item][:product_id])
    cart_item = CartItem.add_or_update(cart: current_cart, product:, quantity:)

    if cart_item.save
      redirect_to cart_path, notice: '商品をカートに追加しました'
    else
      redirect_to product_path(product), alert: '商品をカートに追加できませんでした'
    end
  end

  def update
    cart_item = current_cart.cart_items.find(params[:id])
    if cart_item.update(cart_item_params)
      redirect_to cart_path, notice: '商品の数量を変更しました'
    else
      redirect_to cart_path, alert: '商品の数量を変更できませんでした'
    end
  end

  def destroy
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy!
    redirect_to cart_path, notice: '商品をカートから削除しました'
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:cart_id, :product_id, :quantity)
  end

  def quantity
    params[:cart_item][:quantity].to_i
  end
end
