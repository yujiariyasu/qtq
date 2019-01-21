FactoryBot.define do
  factory :learning do
    sequence(:title) { |n| "Learning-#{n}" }
    description "test learning."
    association :user

    trait :with_comments do
      after(:create) { |learning| create_list(:comments, 5, learning: learning) }
    end
  end
end
