require 'rails_helper'

describe 'Users::Sessions', type: :system do
  let(:user) { create(:user, email: 'example@example.com', password: 'password') }

  describe 'ログイン' do
    it '登録されている場合ログインできること' do
      create(:user, email: 'example@example.com', password: 'password')

      visit new_user_session_path
      fill_in 'user[email]', with: 'example@example.com'
      fill_in 'user[password]', with: 'password'
      click_on 'ログインする'

      expect(page).to have_content 'ログインしました。'
      expect(page).to have_content 'ログアウト'
      expect(page).to have_current_path root_path
    end
  end

  describe 'ログアウト', :js do
    it 'ログアウトできること' do
      sign_in user

      visit root_path
      click_on 'ログアウト'
      page.accept_confirm

      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_current_path root_path
    end
  end
end
