require 'rails_helper'

feature 'Users', type: :feature do
  include FeaturesSpecHelper
  context 'ログイン中' do
    before do
      @user = create(:user)
      login(@user, 'password')
    end
    scenario 'ユーザーshow画面を表示' do
      visit user_path(@user.name)
      expect(page).to have_content '学習件数'
    end

    scenario 'ログアウト' do
      click_button 'demo-menu-lower-right'
      click_link 'ログアウト'
      expect(page).to have_content 'ユーザー登録'
      expect(page).to have_content 'ログイン'
    end

    scenario 'プロフィール編集' do
      click_button 'demo-menu-lower-right'
      click_link 'プロフィール編集'
      expect(page).to have_content '画像を選択する'
      fill_in 'edit-name', with: 'xxxxxxxx'
      fill_in 'edit-email', with: 'xxxx@xxx.xxx'
      click_button '更新する'
      expect(page).to have_content "@#{@user.reload.name}"
    end
  end

  context '未ログイン' do
    before do
      visit root_path
    end

    scenario 'ユーザー新規登録 -> ログアウト -> ログイン' do
      visit new_user_path
      fill_in 'user_name', with: 'test_name'
      fill_in 'user_email', with: 'test@test.test'
      fill_in 'user_password', with: 'password'
      click_button '登録'
      expect(page).to have_content '@test_name'
    end

    scenario 'ユーザーshow画面を表示' do
      user = create(:user)
      visit user_path(user.name)
      expect(page).to have_content '学習件数'
    end

    scenario 'ログイン' do
      user = create(:user, password: 'password')
      click_link 'ログイン'
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content "@#{user.name}"
    end
  end
end
