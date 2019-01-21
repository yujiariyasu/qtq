require 'rails_helper'

feature 'Learnings', type: :feature do
  include FeaturesSpecHelper
  before do
    create(:learning, title: 'test_learning')
    visit root_path
  end
  scenario '学習検索' do
    fill_in 'word', with: 'test'
    find('.learning-search-submit').click
    expect(page).to have_content 'test_learning'
    expect(page).to have_content '検索結果 / test'
    expect(page).to have_content 'test_learning'
  end
end
