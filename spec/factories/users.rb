FactoryBot.define do
  factory :user, aliases: [:active_user, :passive_user] do
    sequence(:name) {|n| "yuji-#{n}"}
    sequence(:email) {|n| "yuji#{n}@example.com"}
    password 'password'
    goal 5

    trait :with_learnings do
      after(:create) { |user| create_list(:learnings, 5, user: user) }
    end
  end
end
