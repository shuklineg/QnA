FactoryBot.define do
  factory :answer do
    body { "Answer body" }
    user { create(:user) }
    question { create(:question) }

    trait :invalid do
      body { nil }
    end

    trait :sequences do
      body
    end
  end
end
