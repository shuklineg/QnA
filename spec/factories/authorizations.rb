FactoryBot.define do
  factory :authorization do
    association :user
    provider { "MyString" }
    uid { "MyString" }
  end
end
