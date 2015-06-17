FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@email.com" }
    sequence(:name) { |n| "User#{n}" }
    password '123456'
  end
end
