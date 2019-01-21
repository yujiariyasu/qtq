FactoryBot.define do
  factory :comments do
    sequence(:body) { |n| "Comment-#{n}" }
    association :user
    association :learning

    trait :with_comments do
      after(:create) { |learning| create_list(:comments, 5, learning: learning) }
    end
  end
end
