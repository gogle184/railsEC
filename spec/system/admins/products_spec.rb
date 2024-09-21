require 'rails_helper'

RSpec.describe 'Admins::Products', type: :system do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe '一覧' do
    before do
      create(:product, name: '商品A', price: 2000)
      create(:product, name: '商品B', price: 3000)
    end

    it '一覧が表示されること' do
      visit admins_products_path

      expect(page).to have_content '商品A'
      expect(page).to have_content '2,200円'
      expect(page).to have_content '商品B'
      expect(page).to have_content '3,300円'
    end
  end

  describe '作成' do
    it '新規商品を登録できること' do
      visit new_admins_product_path
      fill_in 'product[name]', with: '新規商品'
      fill_in 'product[price]', with: 5000
      fill_in 'product[description]', with: 'テスト説明文'
      check 'product[display]'
      click_button '登録する'

      expect(page).to have_content '商品を登録しました'
      expect(page).to have_content '新規商品'
      expect(page).to have_content '5,500円'
      expect(page).to have_selector 'img[src*="default_fruits"]'
      expect(page).to have_current_path admins_products_path
    end

    it '画像を登録できること' do
      visit new_admins_product_path
      fill_in 'product[name]', with: '画像商品'
      fill_in 'product[price]', with: 5000
      fill_in 'product[description]', with: 'テスト説明文'
      check 'product[display]'
      attach_file 'product[image]', Rails.root.join('spec/fixtures/files/sample.png')
      click_button '登録する'

      expect(page).to have_selector 'img[src$="sample.png"]'
      expect(page).to have_current_path admins_products_path
    end
  end

  describe '更新' do
    let(:product) { create(:product, name: '更新前商品', price: 1000) }

    it '商品情報を更新できること' do
      visit edit_admins_product_path(product)
      attach_file 'product[image]', Rails.root.join('spec/fixtures/files/sample.png')
      fill_in 'product[name]', with: '更新後商品'
      fill_in 'product[price]', with: 2000
      click_button '更新する'

      expect(page).to have_content '商品を更新しました'
      expect(page).to have_content '更新後商品'
      expect(page).to have_content '2,200円'
      expect(page).to have_selector 'img[src$="sample.png"]'
      expect(page).to have_current_path admins_products_path
    end
  end

  describe '削除' do
    let(:product) { create(:product, name: '削除商品') }

    it '商品を削除できること' do
      visit admins_product_path(product)
      click_on '商品削除'

      expect(page).to have_content '商品を削除しました'
      expect(page).to have_current_path admins_products_path
      expect(page).not_to have_content '削除商品'
      expect(page).not_to have_content '2,200円'
    end
  end

  describe '並び替え', :js do
    it '商品を並び替えできること' do
      create(:product, name: '商品A', position: 1)
      create(:product, name: '商品B', position: 2)

      visit admins_products_path

      find('.card', text: '商品A').drag_to(find('.card', text: '商品B'))
      visit admins_products_path
      expect(find('.card:nth-of-type(1)')).to have_content('商品B')
      expect(find('.card:nth-of-type(2)')).to have_content('商品A')
    end
  end
end
