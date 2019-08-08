FactoryBot.define do
  factory :comment do
    body { "MyString" }
    association :user
    association :commentable, factory: :question

    trait :sequences do
      body
    end
  end
end
