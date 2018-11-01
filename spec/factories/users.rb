FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "yuji-#{n}"}
    sequence(:email) {|n| "yuji#{n}@example.com"}
  end
end
