require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user:) }
  let(:guest_cart) { create(:cart) }
  let(:first_product) { create(:product, price: 100) }
  let(:second_product) { create(:product, price: 200) }
  let(:third_product) { create(:product, price: 300) }

  before do
    create(:cart_item, cart:, product: first_product, quantity: 5)
    create(:cart_item, cart:, product: second_product, quantity: 1)
    create(:cart_item, cart: guest_cart, product: second_product, quantity: 1)
    create(:cart_item, cart: guest_cart, product: third_product, quantity: 1)
  end

  describe '#combine_and_destroy_other_cart!' do
    it '他のカート情報が、ユーザーのカートに統合されること' do
      cart.combine_and_destroy_other_cart!(guest_cart)

      expect(cart.cart_items.find_by(product: first_product).quantity).to eq 5
      expect(cart.cart_items.find_by(product: second_product).quantity).to eq 2
      expect(cart.cart_items.find_by(product: third_product).quantity).to eq 1
      expect(Cart.exists?(guest_cart.id)).to eq false
    end
  end

  describe '#no_tax_total_price' do
    it 'カート内の税抜合計金額を返すこと' do
      expect(cart.no_tax_total_price).to eq 700
    end
  end

  describe '#tax_included_total_price' do
    it 'カート内の税込合計金額を返すこと' do
      expect(cart.tax_included_total_price).to eq 770
    end
  end

  describe '#total_quantity' do
    it 'カート内の全ての商品の数量の合計を返すこと' do
      expect(cart.total_quantity).to eq 6
    end
  end

  describe '#cash_on_delivery' do
    it '税抜合計金額に応じた代引手数料を返すこと' do
      expect(cart.cash_on_delivery).to eq 330
    end
  end

  describe '#shipping_fee' do
    it '税抜合計金額に応じた送料を返すこと' do
      expect(cart.shipping_fee).to eq 1_320
    end
  end

  describe '#final_total_price' do
    it '最終的な税込合計金額を返すこと' do
      expect(cart.final_total_price).to eq 2_420
    end
  end
end
