FactoryBot.define do
  factory :answer do
    body { "Answer body" }
    association :user
    association :question

    trait :invalid do
      body { nil }
    end

    trait :sequences do
      body
    end
  end
end
