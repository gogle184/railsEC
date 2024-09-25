module OrderWithItems
  extend ActiveSupport::Concern

  included do
    def build_with_cart_items(cart_items)
      cart_items.each do |cart_item|
        order_items.build(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          tax_in_price: cart_item.product.add_tax_price
        )
      end
    end
  end
end
