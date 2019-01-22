FactoryBot.define do
  factory :learning_tag do
    association :learning
    association :tag
  end
end
