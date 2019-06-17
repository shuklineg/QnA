FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :title do |n|
    "Tilte text #{n}"
  end

  sequence :body do |n|
    "Body text #{n}"
  end
end
