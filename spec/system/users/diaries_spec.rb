require 'rails_helper'

RSpec.describe 'Users::Diaries', type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '一覧' do
    it '公開フラグがtrueの投稿が表示されること' do
      create(:diary, user:, title: '公開日記', body: '本文', display: true)
      create(:diary, :undisplay, user:, title: '非公開日記', body: '非公開の内容')
      orher_user = create(:user)
      create(:diary, user: other_user, title: '他のユーザーの日記', body: '他のユーザーの内容', display: true)

      visit users_diaries_path

      expect(page).to have_content '公開日記'
      expect(page).to have_content '本文'
      expect(page).not_to have_content '非公開日記'
      expect(page).not_to have_content '本文'
      expect(page).not_to have_content '他のユーザーの日記'
      expect(page).not_to have_content '他のユーザーの内容'
    end
  end

  describe '作成' do
    it '日記が作成できること' do
      visit new_users_diary_path

      fill_in 'タイトル', with: '新規日記'
      fill_in '本文', with: '本文'
      check '公開する'
      click_button '登録する'

      expect(page).to have_content '日記を作成しました。'
      expect(page).to have_content '新規日記'
      expect(page).to have_content '本文'
    end
  end

  describe '詳細' do
    let!(:diary) { create(:diary, user: user, title: 'タイトル', body: '本文', display: true) }
    let!(:other_user) { create(:user, display_name: 'ボブ') }
    let!(:favorite) { create(:favorite, user: other_user, diary: diary) }
    let!(:comment) { create(:comment, user: other_user, diary: diary, content: 'コメントです') }

    it '日記の詳細が表示されること' do
      visit users_diary_path(diary)

      expect(page).to have_content 'タイトル'
      expect(page).to have_content '本文'
      expect(page).to have_content 'ボブ'
      expect(page).to have_content 'コメントです'
    end
  end

  describe '編集' do
    let!(:diary) { create(:diary, user: user, title: '編集前', body: '本文', display: true) }

    it '日記が編集できること' do
      visit edit_users_diary_path(diary)

      fill_in 'タイトル', with: '編集後'
      fill_in '本文', with: '編集後の本文'
      uncheck '公開する'
      click_button '更新する'

      expect(page).to have_content '日記を更新しました。'
      expect(page).to have_content '編集後'
      expect(page).to have_content '編集後の本文'
      expect(page).not_to have_content '公開日記'
      expect(page).not_to have_content '本文'
    end
  end

  describe '削除', :js do
    let!(:diary) { create(:diary, user: user, title: '削除対象', body: '本文', display: true) }

    it '日記が削除できること' do
      visit users_diaries_path

      click_link '削除', href: users_diary_path(diary)

      expect(page).to have_content '日記を削除しました。'
      expect(page).not_to have_content '削除対象'
      expect(page).not_to have_content '本文'
    end
  end
end
