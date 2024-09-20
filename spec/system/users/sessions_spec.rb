require 'rails_helper'

describe 'Users::Sessions', type: :system do
  let(:confirmed_user) { create(:user, email: 'example@example.com', password: 'password') }
  let(:unconfirmed_user) { create(:user, :unconfirmed_user, email: 'unconfirmed@example.com', password: 'password') }

  describe 'ログイン' do
    it '認証されている場合ログインできること' do
      visit new_user_session_path
      fill_in 'user[email]', with: 'example@example.com'
      fill_in 'user[password]', with: 'password'
      click_on 'ログインする'

      expect(page).to have_content 'ログインしました。'
      expect(page).to have_content 'ログアウト'
      expect(page).to have_current_path root_path
    end

    it '認証されていない場合ログインできないこと' do
      visit new_user_session_path
      fill_in 'user[email]', with: 'unconfirmed@example.com'
      fill_in 'user[password]', with: 'password'
      click_on 'ログインする'

      expect(page).to have_content 'メールアドレスの本人確認が必要です。'
      expect(page).to have_current_path new_user_session_path
    end
  end

  describe 'ログアウト', :js do
    it 'ログアウトできること' do
      sign_in confirmed_user

      visit root_path
      click_on 'ログアウト'
      page.accept_confirm

      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_current_path root_path
    end
  end
end
