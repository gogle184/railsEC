require 'rails_helper'

RSpec.describe 'Admins::Users', type: :system do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe '一覧' do
    it '一覧が表示されること' do
      alice = create(:user, email: 'alice@example.com', display_name: 'Alice', name: 'AliceSato')
      bob = create(:user, email: 'bob@example.com', display_name: 'ボブ', name: '伊藤ボブ')

      visit admins_users_path

      expect(page).to have_content 'alice@example.com Alice AliceSato 詳細 削除', normalize_ws: true
      expect(page).to have_link '詳細', href: admins_user_path(alice)
      within('tr', text: 'alice@example.com') do
        expect(page).to have_button '削除'
      end

      expect(page).to have_content 'bob@example.com ボブ 伊藤ボブ 詳細 削除', normalize_ws: true
      expect(page).to have_link '詳細', href: admins_user_path(bob)
      within('tr', text: 'bob@example.com') do
        expect(page).to have_button '削除'
      end
    end
  end

  describe '詳細' do
    let(:user) do
      create(:user, email: 'alice@example.com', display_name: 'Alice', name: '佐藤アリス', phone_number: '00011112222', postal_code: '3334444',
                    address: '東京都中野区中野0-0')
    end

    it '詳細が表示されること' do
      visit admins_user_path(user)

      expect(page).to have_content 'alice@example.com'
      expect(page).to have_content 'Alice'
      expect(page).to have_content '佐藤アリス'
      expect(page).to have_content '00011112222'
      expect(page).to have_content '3334444'
      expect(page).to have_content '東京都中野区中野0-0'
      expect(page).to have_link '戻る', href: admins_users_path
      expect(page).to have_link 'ユーザー編集', href: edit_admins_user_path(user)
    end
  end

  describe '更新' do
    let(:user) { create(:user, email: 'example@example.com', display_name: 'Alice', name: '佐藤アリス') }

    it '更新できること' do
      visit edit_admins_user_path(user)

      fill_in 'user[email]', with: 'alice_sato@example.com'
      fill_in 'user[name]', with: 'Alice Sato'
      click_button '更新'

      expect(page).to have_content 'ユーザーを更新しました'
      expect(page).to have_content 'alice_sato@example.com'
      expect(page).to have_content 'Alice Sato'
      expect(page).to have_current_path admins_users_path
    end
  end

  describe '削除', :js do
    it 'ユーザーを削除できること' do
      create(:user, display_name: 'Alice')

      visit admins_users_path
      click_on '削除'
      page.accept_confirm

      expect(page).to have_content 'ユーザーを削除しました'
      expect(page).to have_current_path admins_users_path
      expect(page).not_to have_content 'Alice'
    end
  end
end
