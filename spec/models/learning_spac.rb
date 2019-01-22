require 'rails_helper'

RSpec.describe Learning, type: :model do
  it "is valid with a title" do
    learning = Learning.new(
      title: "test"
    )
    expect(learning).to be_valid
  end

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to_not validate_presence_of :description }
end
