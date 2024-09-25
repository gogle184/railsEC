require 'rails_helper'

RSpec.describe 'Users::Orders', type: :system do
  describe '一覧' do
    it '注文の一覧を取得できること' do
      user = create(:user)
      product_first = create(:product, name: '商品3', price: 1_000)
      product_second = create(:product, name: '商品4', price: 1_500)
      order = create(:order, user:, cash_on_delivery: 330, shipping_fee: 660, schedule_time: 1, created_at: '2024-09-24 12:00:00')
      order.order_items.create!(product: product_first, quantity: 1, tax_in_price: 1_100)
      order.order_items.create!(product: product_second, quantity: 2, tax_in_price: 1_650)

      sign_in user
      visit users_orders_path

      expect(page).to have_content '2024年09月24日'
      expect(page).to have_content '処理中'
      expect(page).to have_content(/\d{4}-\d{2}-\d{2}/)
      expect(page).to have_content '8-12'
      expect(page).to have_link '詳細', href: users_order_path(order)
    end
  end

  describe '照会' do
    it '注文の詳細を取得できること' do
      user = create(:user, name: '田中太郎', postal_code: '1234567', address: '東京都渋谷区')
      product_first = create(:product, name: '商品3', price: 1_000)
      order = create(:order, user:, cash_on_delivery: 330, shipping_fee: 660, schedule_time: 1, created_at: '2024-09-24 12:00:00')
      order.order_items.create!(product: product_first, quantity: 1, tax_in_price: 1_100)

      sign_in user
      visit users_order_path(order)

      expect(page).to have_content '注文日時 2024年09月24日'
      expect(page).to have_content 'ステータス 処理中'
      expect(page).to have_content '配送完了日時'
      expect(page).to have_content '希望配送日'
      expect(page).to have_content '希望配送時間 8-12'
      expect(page).to have_content '登録者名 田中太郎'
      expect(page).to have_content '郵便番号 1234567'
      expect(page).to have_content '住所 東京都渋谷区'
      expect(page).to have_content '商品3'
      expect(page).to have_content '1,100円'
      expect(page).to have_content '1'
      expect(page).to have_content '合計点数 1'
      expect(page).to have_content '小計 1,100円'
      expect(page).to have_content '代引手数料 330円'
      expect(page).to have_content '送料 660円'
      expect(page).to have_content '合計請求金額 2,090円'
    end
  end
end
