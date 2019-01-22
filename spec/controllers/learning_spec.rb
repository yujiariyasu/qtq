require 'rails_helper'

describe LearningsController, type: :controller do
  describe "#search" do
    before do
      @learning = create(:learning, title: 'y')
      create(:learning, title: 'x')
      create(:learning, title: 'yz')
      create(:learning, title: 'xyz')
    end

    it '@learningsに検索ワードに対応するtitleのlearningsが入ること' do
      learnings = Learning.where(title: ['x', 'xyz']).order(created_at: :desc)
      get :search, params: { word: 'x' }
      expect(assigns(:learnings)).to eq(learnings)
    end

    it '@learningsに検索ワードに対応するtitleのlearningsと対応するnameのtagに紐つくlearningsが入ること' do
      tag = create(:tag, name: 'xx')
      create(:learning_tag, tag: tag, learning: @learning)
      learnings = Learning.where(title: ['x', 'xyz']).order(created_at: :desc)
      tag_learnings = tag.learnings.order(created_at: :desc)
      get :search, params: { word: 'x' }
      expect(assigns(:learnings)).to eq(learnings + tag_learnings)
    end
  end
end
