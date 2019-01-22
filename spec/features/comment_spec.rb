require 'rails_helper'

feature 'Comments', type: :feature do
  include FeaturesSpecHelper
  before do
    create(:user)
    login(User.first, 'password')
    @learning = create(:learning)
    visit learning_path(@learning)
  end
  scenario 'コメント投稿 -> 編集 -> 削除', js: true do
    fill_in 'comment_body', with: 'test_comment'
    click_button '投稿'
    expect(page).to have_content 'test_comment'

    find('.comment-edit-modal-button').click
    fill_in 'edit-comment-body', with: '編集後コメント'
    click_button '編集'
    expect(page).to have_content '編集後コメント'
    expect(page).to have_content 'コメントを編集しました。'

    link = find('.comment-delete-button')
    expect(link['data-confirm']).to eq '本当に削除しますか？'
    page.dismiss_confirm '本当に削除しますか？' do
      link.click
    end
    expect(page).to have_content '編集後コメント'
    page.accept_confirm '本当に削除しますか？' do
      link.click
    end
    expect(page).to_not have_content '編集後コメント'
  end
end
