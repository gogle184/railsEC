require 'rails_helper'

RSpec.describe 'Orders', type: :system do
  describe '注文' do
    it '注文が完了すること' do
      user = create(:user, name: '田中太郎', postal_code: '1234567', address: '東京都渋谷区')
      product_first = create(:product, name: 'りんご', price: 1000)
      product_second = create(:product, name: 'ばなな', price: 2000)
      cart = create(:cart, user:)
      create(:cart_item, cart:, product: product_first, quantity: 2)
      create(:cart_item, cart:, product: product_second, quantity: 3)

      sign_in user
      visit cart_path
      click_on '購入手続きに進む'

      expect(page).to have_current_path confirm_order_path
      expect(page).to have_content 'りんご'
      expect(page).to have_content '1,100円'
      expect(page).to have_content '点数 2'
      expect(page).to have_content 'ばなな'
      expect(page).to have_content '2,200円'
      expect(page).to have_content '点数 3'
      expect(page).to have_content '合計点数 5'
      expect(page).to have_content '小計 8,800円'
      expect(page).to have_content '代引手数料 330円'
      expect(page).to have_content '送料 1,320円'
      expect(page).to have_content '合計請求金額 10,450円'
      expect(page).to have_content '送付先情報'
      expect(page).to have_content '登録者名 田中太郎'
      expect(page).to have_content '郵便番号 1234567'
      expect(page).to have_content '住所 東京都渋谷区'

      fill_in 'order[schedule_date]', with: 3.business_days.from_now.to_date
      select '12-14', from: 'order[schedule_time]'

      expect do
        click_on '注文確定'
        expect(page).to have_content '注文が完了しました'
        user.reload
      end.to have_enqueued_mail(UserMailer, :order_accepted).with(user.orders.last).once
    end
  end
end
