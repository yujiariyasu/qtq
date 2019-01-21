FactoryBot.define do
  factory :learning do
    sequence(:title) { |n| "Learning-#{n}" }
    description "test learning."
    next_review_date Date.tomorrow
    association :user

    trait :with_comments do
      after(:create) { |learning| create_list(:comments, 5, learning: learning) }
    end
  end
end
