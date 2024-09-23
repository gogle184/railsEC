class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  class << self
    def build_with_order_items(attributes)
      cart_items = attributes.delete(:cart_items)
      order = build(attributes)

      cart_items.each do |cart_item|
        order.order_items.build(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end
      order.schedule_date ||= nil
      order.schedule_time ||= nil
      order
    end
  end

  def tax_included_total_price(no_tax_total_price)
    (no_tax_total_price * 1.10).floor
  end

  def cash_on_delivery(no_tax_total_price)
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

  def shipping_fee(total_quantity)
    660 + ((total_quantity / 5).ceil * 660)
  end

  def final_total_price(no_tax_total_price, total_quantity)
    tax_included_total_price(no_tax_total_price) + cash_on_delivery(no_tax_total_price) + shipping_fee(total_quantity)
  end
end
