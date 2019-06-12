FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyString" }

    trait :invalid do
      title { nil }
    end
  end
end
