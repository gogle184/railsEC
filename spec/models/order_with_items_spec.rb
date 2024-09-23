# TODO: リファアクタリング。concerに置くのも怪しい
require 'rails_helper'

RSpec.describe OrderWithItems, type: :concern do
  let(:user) { create(:user) }
  let(:product) { create(:product, price: 1000) }
  let(:cart_item) { create(:cart_item, product:, quantity: 2) }
  let(:cart) { create(:cart, user:) }
  let(:order) { build(:order, user:) }

  describe '#build_with_cart_items' do
    it 'cart_itemsからorder_itemsを生成する' do
      order.build_with_cart_items([cart_item])
      expect(order.order_items.size).to eq 1
      expect(order.order_items.first.product_id).to eq cart_item.product_id
      expect(order.order_items.first.quantity).to eq cart_item.quantity
      expect(order.order_items.first.tax_in_price).to eq product.add_tax_price
    end
  end
end
