FactoryBot.define do
  factory :question do
    title { "Question title" }
    body { "Question body" }
    association :user

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :sequences do
      title
      body
    end
  end
end
