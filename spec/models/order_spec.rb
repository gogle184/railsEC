# TODO: リファクタリング
require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product, price: 1000) }
  let(:cart) { create(:cart, user:) }
  let(:cart_item) { create(:cart_item, cart:, product:, quantity: 2) }
  let(:order) { build(:order, user:) }

  describe 'バリデーション' do
    it 'schedule_dateが存在する場合は有効である' do
      order.schedule_date = Order.min_schedule_date
      expect(order).to be_valid
    end

    it 'schedule_dateが無い場合は無効である' do
      order.schedule_date = nil
      expect(order).not_to be_valid
      expect(order.errors[:schedule_date]).to include('を入力してください')
    end

    it 'schedule_dateが業務日数範囲内である場合は有効' do
      order.schedule_date = 5.business_days.from_now.to_date
      expect(order).to be_valid
    end

    it 'schedule_dateが業務日数範囲外である場合は無効' do
      order.schedule_date = 2.business_days.from_now.to_date
      expect(order).not_to be_valid
      expect(order.errors[:schedule_date]).to include('は3営業日から14営業日の範囲で選択してください')
    end
  end

  describe '#tax_included_total_price' do
    it '税抜き金額から正しい税込み金額を返す' do
      no_tax_total_price = 1000
      expect(order.tax_included_total_price(no_tax_total_price)).to eq 1100
    end
  end

  describe '#cash_on_delivery_method' do
    it '1万円未満で330円の代引き手数料を返す' do
      expect(order.cash_on_delivery_method(9999)).to eq 330
    end

    it '1万円以上3万円未満で440円の代引き手数料を返す' do
      expect(order.cash_on_delivery_method(10000)).to eq 440
    end
  end

  describe '#shipping_fee_method' do
    it '5つごとに660円加算されること' do
      total_quantity = 7
      expect(order.shipping_fee_method(total_quantity)).to eq 1320
    end
  end

  describe '#final_total_price' do
    it '最終合計金額を計算する' do
      tax_in_total_price = 1100
      total_quantity = 3
      expect(order.final_total_price(tax_in_total_price, total_quantity)).to eq 2090
    end
  end
end
