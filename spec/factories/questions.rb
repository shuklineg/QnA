FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyString" }

    trait :invalid do
      title { nil }
    end

    trait :sequences do
      title
      body
    end
  end
end
