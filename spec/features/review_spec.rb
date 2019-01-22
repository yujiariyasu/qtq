require 'rails_helper'

feature 'Reviews', type: :feature do
  before do
    @user = create(:user)
    login(@user)
    @learning = create(:learning, title: 'test_learning', user: @user)
    visit learning_path(@learning)
  end

  scenario '復習の記録' do
    expect(page).to have_content @learning.title
    find('.review-modal').click
    fill_in 'description', with: 'xyz'
    click_button '復習'
    expect(page).to have_content '復習を記録しました。'
    expect(page).to have_content '[復習メモ] '
    expect(page).to have_content 'xyz'
    expect(current_path).to eq learning_path(@learning)
  end
end
