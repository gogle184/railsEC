require 'rails_helper'

RSpec.describe 'Tops', type: :system do
  describe '一覧' do
    it '公開フラグがtrueの商品が表示されること' do
      create(:product, name: '公開商品', price: 100)
      create(:product, :undisplay, name: '非公開商品', price: 200)

      visit root_path

      expect(page).to have_content '公開商品'
      expect(page).to have_content '110'
      expect(page).not_to have_content '非公開商品'
      expect(page).not_to have_content '220'
    end
  end
end
