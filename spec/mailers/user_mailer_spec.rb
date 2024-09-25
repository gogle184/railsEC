require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'order_accepted' do
    it '宛先がOrderに紐づくUserのemailであること' do
      user = create(:user, email: 'alice@example.com')
      product = create(:product)
      order = create(:order, user:)
      order.order_items.create!(product:, quantity: 1, tax_in_price: 100)

      mail = UserMailer.order_accepted(order)
      expect(mail.subject).to eq('【自動送信】ご注文を承りました')
      expect(mail.to).to eq(['alice@example.com'])
      expect(mail.from).to eq(['sakura-market@example.com'])
    end

    it 'メールの本文に注文情報が含まれていること' do
      user = create(:user)
      product_first = create(:product, name: '商品1', price: 1_000)
      product_second = create(:product, name: '商品2', price: 1_500)
      order = create(:order, user:, cash_on_delivery: 330, shipping_fee: 660, schedule_date: 3.business_days.from_now.to_date, schedule_time: 1)
      order.order_items.create!(product: product_first, quantity: 1, tax_in_price: 1_100)
      order.order_items.create!(product: product_second, quantity: 2, tax_in_price: 1_650)

      mail = UserMailer.order_accepted(order)
      expect(mail.body).to match user.name
      expect(mail.body).to match('商品1')
      expect(mail.body).to match('価格: 1,100円')
      expect(mail.body).to match('点数: 1')
      expect(mail.body).to match('商品2')
      expect(mail.body).to match('価格: 1,650円')
      expect(mail.body).to match('点数: 2')
      expect(mail.body).to match('希望配送日')
      expect(mail.body).to match('希望配送時間 8-12')
      expect(mail.body).to match('代引手数料 330円')
      expect(mail.body).to match('送料 660円')
      expect(mail.body).to match('合計点数 3')
      expect(mail.body).to match('合計請求金額 5,390円')
    end
  end

  describe 'order_shipped' do
    it '宛先がOrderに紐づくUserのemailであること' do
      user = create(:user, email: 'alice@example.com')
      product = create(:product)
      order = create(:order, user:)
      order.order_items.create!(product:, quantity: 1, tax_in_price: 100)

      mail = UserMailer.order_shipped(order)
      expect(mail.subject).to eq('【自動送信】商品を発送しました')
      expect(mail.to).to eq(['alice@example.com'])
      expect(mail.from).to eq(['sakura-market@example.com'])
    end

    it 'メールの本文に注文情報が含まれていること' do
      user = create(:user)
      product_first = create(:product, name: '商品3', price: 1_000)
      product_second = create(:product, name: '商品4', price: 1_500)
      order = create(:order, user:, cash_on_delivery: 330, shipping_fee: 660, schedule_date: 3.business_days.from_now.to_date, schedule_time: 1)
      order.order_items.create!(product: product_first, quantity: 1, tax_in_price: 1_100)
      order.order_items.create!(product: product_second, quantity: 2, tax_in_price: 1_650)

      mail = UserMailer.order_shipped(order)
      expect(mail.body).to match user.name
      expect(mail.body).to match('商品3')
      expect(mail.body).to match('価格: 1,100円')
      expect(mail.body).to match('点数: 1')
      expect(mail.body).to match('商品4')
      expect(mail.body).to match('価格: 1,650円')
      expect(mail.body).to match('点数: 2')
      expect(mail.body).to match('希望配送日')
      expect(mail.body).to match('希望配送時間 8-12')
      expect(mail.body).to match('代引手数料 330円')
      expect(mail.body).to match('送料 660円')
      expect(mail.body).to match('合計点数 3')
      expect(mail.body).to match('合計請求金額 5,390円')
    end
  end

  describe 'order_completed' do
    it '宛先がOrderに紐づくUserのemailであること' do
      user = create(:user, email: 'alice@example.com')
      product = create(:product)
      order = create(:order, user:)
      order.order_items.create!(product:, quantity: 1, tax_in_price: 100)

      mail = UserMailer.order_completed(order)
      expect(mail.subject).to eq('【自動送信】商品をお届けしました')
      expect(mail.to).to eq(['alice@example.com'])
      expect(mail.from).to eq(['sakura-market@example.com'])
    end

    it 'メールの本文に注文情報が含まれていること' do
      user = create(:user)
      product_first = create(:product, name: '商品1', price: 1_000)
      product_second = create(:product, name: '商品2', price: 1_500)
      order = create(:order, user:, cash_on_delivery: 330, shipping_fee: 660, schedule_date: 3.business_days.from_now.to_date, schedule_time: 1)
      order.order_items.create!(product: product_first, quantity: 1, tax_in_price: 1_100)
      order.order_items.create!(product: product_second, quantity: 2, tax_in_price: 1_650)

      mail = UserMailer.order_completed(order)
      expect(mail.body).to match user.name
      expect(mail.body).to match('商品1')
      expect(mail.body).to match('価格: 1,100円')
      expect(mail.body).to match('点数: 1')
      expect(mail.body).to match('商品2')
      expect(mail.body).to match('価格: 1,650円')
      expect(mail.body).to match('点数: 2')
      expect(mail.body).to match('希望配送日')
      expect(mail.body).to match('希望配送時間 8-12')
      expect(mail.body).to match('代引手数料 330円')
      expect(mail.body).to match('送料 660円')
      expect(mail.body).to match('合計点数 3')
      expect(mail.body).to match('合計請求金額 5,390円')
    end
  end

  describe 'order_canceled' do
    it '宛先がOrderに紐づくUserのemailであること' do
      user = create(:user, email: 'alice@example.com')
      product = create(:product)
      order = create(:order, user:)
      order.order_items.create!(product:, quantity: 1, tax_in_price: 100)

      mail = UserMailer.order_canceled(order)
      expect(mail.subject).to eq('【自動送信】注文をキャンセルしました')
      expect(mail.to).to eq(['alice@example.com'])
      expect(mail.from).to eq(['sakura-market@example.com'])
    end

    it 'メールの本文に注文情報が含まれていること' do
      user = create(:user)
      product_first = create(:product, name: '商品1', price: 1_000)
      product_second = create(:product, name: '商品2', price: 1_500)
      order = create(:order, user:, cash_on_delivery: 330, shipping_fee: 660, schedule_date: 3.business_days.from_now.to_date, schedule_time: 1)
      order.order_items.create!(product: product_first, quantity: 1, tax_in_price: 1_100)
      order.order_items.create!(product: product_second, quantity: 2, tax_in_price: 1_650)

      mail = UserMailer.order_canceled(order)
      expect(mail.body).to match user.name
      expect(mail.body).to match('商品1')
      expect(mail.body).to match('価格: 1,100円')
      expect(mail.body).to match('点数: 1')
      expect(mail.body).to match('商品2')
      expect(mail.body).to match('価格: 1,650円')
      expect(mail.body).to match('点数: 2')
      expect(mail.body).to match('希望配送日')
      expect(mail.body).to match('希望配送時間 8-12')
      expect(mail.body).to match('代引手数料 330円')
      expect(mail.body).to match('送料 660円')
      expect(mail.body).to match('合計点数 3')
      expect(mail.body).to match('合計請求金額 5,390円')
    end
  end
end
