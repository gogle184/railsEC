class Cart::CartItemsController < ApplicationController
  def create
    product = Product.find(params[:cart_item][:product_id])
    cart_item = CartItem.add_or_update(cart: current_cart, product:, quantity:)

    if cart_item.save
      redirect_to cart_path, notice: t('common.controller.create.success', model: CartItem.model_name.human)
    else
      flash.now[:alert] = t('common.controller.create.failed', model: CartItem.model_name.human)
      render 'products/show', status: :unprocessable_entity
    end
  end

  def update
    cart_item = current_cart.cart_items.find(params[:id])
    if cart_item.update(cart_item_params)
      redirect_to cart_path, notice: t('common.controller.update.success', model: CartItem.model_name.human)
    else
      flash.now[:alert] = t('common.controller.update.failed', model: CartItem.model_name.human)
      render 'cart/show', status: :unprocessable_entity
    end
  end

  def destroy
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy!
    redirect_to cart_path, notice: t('common.controller.destroy.success', model: CartItem.model_name.human)
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:cart_id, :product_id, :quantity)
  end

  def quantity
    params[:cart_item][:quantity].to_i
  end
end
