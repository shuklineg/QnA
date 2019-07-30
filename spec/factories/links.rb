FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { 'http://my.link' }
    association :linkable, factory: :question
  end
end
