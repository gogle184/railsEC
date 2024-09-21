require 'rails_helper'

RSpec.describe 'Users::Passwords', type: :system do
  it 'パスワード再設定ができること' do
    create(:user, :unconfirmed_user, email: 'example@example.com', password: 'password')

    visit new_user_password_path
    fill_in 'user[email]', with: 'example@example.com'
    click_on 'パスワードを再設定する'
    expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします'

    mail = ActionMailer::Base.deliveries.last
    password_reset_link = URI::DEFAULT_PARSER.extract(mail.body.to_s, :http).find { |link| link.include?('reset_password_token=') }
    visit password_reset_link
    fill_in 'user[password]', with: 'password2'
    fill_in 'user[password_confirmation]', with: 'password2'
    click_on 'パスワードを変更する'

    expect(page).to have_content 'パスワードが正しく変更されました。'
    expect(page).to have_current_path new_user_session_path
  end
end
