FactoryBot.define do
  factory :comment do
    body { "MyString" }
    user { nil }
    commentable { nil }
  end
end
