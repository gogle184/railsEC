require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user:) }
  let(:first_product) { create(:product, price: 100) }
  let(:second_product) { create(:product, price: 200) }

  describe '.add_or_update' do
    context 'カートに同じ商品が存在する場合' do
      before do
        create(:cart_item, cart:, product: first_product, quantity: 2)
      end

      it '既存の商品の数量が更新されること' do
        cart_item = CartItem.add_or_update(cart:, product: first_product, quantity: 3)
        cart_item.save

        expect(cart_item.quantity).to eq 5
      end
    end

    context 'カートに同じ商品が存在しない場合' do
      it '新しい商品が追加されること' do
        cart_item = CartItem.add_or_update(cart:, product: second_product, quantity: 3)
        cart_item.save

        expect(cart_item.quantity).to eq 3
      end
    end
  end

  describe '#validate_product_is_displayed' do
    it '未公開の商品は登録できないこと' do
      hidden_product = create(:product, display: false)

      cart_item = build(:cart_item, cart:, product: hidden_product)
      cart_item.save

      expect(cart_item.errors[:product]).to include('がカートに追加できませんでした')
    end
  end
end
