require 'rails_helper'

feature 'ユーザー画面関連' do
  include FeaturesSpecHelper
  before do
    @user = create(:user, name: 'yujiariyasu', email: 'yuji@xxx.com')
  end
  context 'ログイン中' do
    before do
      login(@user, 'password')
    end
    it 'ユーザーshow画面が表示されること' do
      visit user_path(@user.name)
      expect(page).to have_content '学習件数'
    end
  end
  context '未ログイン' do
    it 'ユーザーshow画面が表示されること' do
      visit user_path(@user.name)
      expect(page).to have_content '学習件数'
    end
  end
end
