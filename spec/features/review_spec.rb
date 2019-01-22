require 'rails_helper'

feature 'Learnings', type: :feature, js: true do
  include FeaturesSpecHelper
  before do
    @user = create(:user)
    login(@user)
    @learning = create(:learning, title: 'test_learning', user: @user)
    visit root_path
  end
  scenario '学習検索' do
    fill_in 'word', with: 'test'
    find('.learning-search-submit').click
    expect(page).to have_content 'test_learning'
    expect(page).to have_content '検索結果 / test'
    expect(page).to have_content 'test_learning'
  end

  scenario '学習投稿' do
    find('.header-learning-new-modal').click
    fill_in 'learning_title', with: 'test-title'
    fill_in 'learning_description', with: '12345'
    click_button '記録をつける'
    expect(page).to have_content '学習を登録しました。'
    expect(page).to have_content 'test-title'
    expect(page).to have_content '12345'
  end

  scenario '学習編集' do
    visit learning_path(@learning)
    expect(page).to have_content @learning.title
    find('.learning-edit-modal').click
    fill_in 'learning_title', with: 'test!!!'
    fill_in 'learning_description', with: '9999'
    click_button '編集する'
    expect(page).to have_content '学習を編集しました。'
    expect(page).to have_content 'test!!!'
    expect(page).to have_content '9999'
  end

  scenario '学習削除' do
    visit learning_path(@learning)
    expect(page).to have_content @learning.title
    link = find '.learning-delete-button'
    expect(link['data-confirm']).to eq '本当に削除しますか？'
    page.accept_confirm '本当に削除しますか？' do
      link.click
    end
    expect(current_path).to eq user_path(@user.name)
  end
end
