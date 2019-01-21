require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    create(:learning)
  end
  it "is valid with a body" do
    comment = Comment.new(
      body: "test",
      user: User.first,
      learning: Learning.first
    )
    expect(comment).to be_valid
  end

  it { is_expected.to validate_presence_of :body }
end
