FactoryBot.define do
  factory :answer do
    body { "MyString" }

    trait :invalid do
      body { nil }
    end

    trait :sequences do
      body
    end
  end
end
