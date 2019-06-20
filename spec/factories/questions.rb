FactoryBot.define do
  factory :question do
    title { "Question title" }
    body { "Question body" }
    user { create(:user) }

    trait :invalid do
      title { nil }
    end

    trait :sequences do
      title
      body
    end
  end
end
