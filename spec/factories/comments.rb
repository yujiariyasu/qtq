FactoryBot.define do
  factory :comments do
    sequence(:body) { |n| "Comment-#{n}" }
    association :user
    association :learning
  end
end
