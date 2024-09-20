require 'rails_helper'

RSpec.describe 'Users::Confirmations', type: :system do
  describe 'アカウント認証' do
    let(:user) { create(:user, :unconfirmed_user, email: 'example@example.com') }

    it '認証メールを再送できること' do
      visit new_user_confirmation_path
      fill_in 'user[email]', with: 'example@example.com'
      click_on '確認メール再送信'

      expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡します。'
      expect(page).to have_current_path new_user_session_path

      mail = ActionMailer::Base.deliveries.last
      confirmation_link = URI::DEFAULT_PARSER.extract(mail.body.to_s, :http).first
      visit confirmation_link

      expect(page).to have_content 'メールアドレスが確認できました。'
      expect(page).to have_current_path new_user_session_path
    end
  end
end
