FactoryBot.define do
  sequence :title do |n|
    "Question tilte #{n}"
  end

  sequence :body do |n|
    "Question body #{n}"
  end

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
