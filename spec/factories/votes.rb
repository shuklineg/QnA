FactoryBot.define do
  factory :vote do
    user { create(:user) }
  end
end
