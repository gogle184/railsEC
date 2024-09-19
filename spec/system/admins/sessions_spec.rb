require 'rails_helper'

RSpec.describe 'Admins::Sessions', type: :system do
  let!(:admin) { create(:admin, email: 'admin@example.com', password: 'password') }

  describe 'ログイン' do
    it 'ログインできること' do
      visit new_admin_session_path
      fill_in 'メールアドレス', with: 'hoge'
      fill_in 'パスワード', with: 'password'
      click_on 'ログイン'

      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'

      fill_in 'メールアドレス', with: 'admin@example.com'
      fill_in 'パスワード', with: 'password'
      click_on 'ログイン'

      expect(page).to have_content 'ログインしました。'
      expect(page).to have_current_path admins_products_path, ignore_query: true
      expect(page).to have_content 'ログアウト'
    end
  end

  describe 'ログアウト' do
    before do
      sign_in admin
    end

    it 'ログアウトできること' do
      visit admins_products_path
      click_on 'ログアウト'

      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end
end
