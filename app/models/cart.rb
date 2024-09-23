class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def combine_and_destroy_other_cart!(guest_cart)
    guest_cart.cart_items.each do |guest_cart_item|
      existing_cart_item = cart_items.find_by(product_id: guest_cart_item.product_id)

      if existing_cart_item
        existing_cart_item.update(quantity: existing_cart_item.quantity + guest_cart_item.quantity)
      else
        cart_items.create(
          product_id: guest_cart_item.product_id,
          quantity: guest_cart_item.quantity
        )
      end
    end
    guest_cart.destroy
  end

  def no_tax_total_price
    cart_items.sum { |item| item.quantity * item.product.price }
  end

  def tax_included_total_price
    (no_tax_total_price * 1.10).floor
  end

  def total_quantity
    cart_items.sum(:quantity)
  end

  def cash_on_delivery
    case no_tax_total_price
    when 0..10_000
      330
    when 10_000..30_000
      440
    when 30_000..100_000
      660
    else
      1_100
    end
  end

  def shipping_fee
    660 + ((total_quantity / 5).ceil * 660)
  end

  def final_total_price
    tax_included_total_price + cash_on_delivery + shipping_fee
  end
end
