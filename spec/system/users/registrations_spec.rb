require 'rails_helper'

RSpec.describe 'Users::Resistrations', type: :system do
  describe '作成' do
    it 'アカウントが作成できること' do
      visit new_user_registration_path
      fill_in 'user[display_name]', with: 'Tanaka'
      fill_in 'user[name]', with: '田中太郎'
      fill_in 'user[phone_number]', with: '00011112222'
      fill_in 'user[postal_code]', with: '0001111'
      fill_in 'user[address]', with: 'hogehoge県fuga市'
      fill_in 'user[email]', with: 'example@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'アカウント登録'

      expect(page).to have_current_path root_path

      confirmation_email = ActionMailer::Base.deliveries.last
      expect(confirmation_email.to).to eq(['example@example.com'])
      confirmation_link = URI::DEFAULT_PARSER.extract(confirmation_email.body.to_s, :http).find { |link| link.include?('confirmation_token=') }
      visit confirmation_link
      expect(page).to have_content 'メールアドレスが確認できました'
      expect(page).to have_current_path new_user_session_path
    end
  end
end
