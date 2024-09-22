class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :order_by_oldest, -> { order(:id) }

  def self.add_or_update(cart:, product:, quantity:)
    cart_item = cart.cart_items.find_or_initialize_by(product: product)
    if cart_item.persisted?
      cart_item.quantity += quantity.to_i
    else
      cart_item.quantity = quantity.to_i
    end
    cart_item
  end

  def sum_price
    quantity * product.price
  end
end
