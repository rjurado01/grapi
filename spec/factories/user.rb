FactoryGirl.define do
  factory :user_unconfirmed, class: User do
    sequence(:email) { |n| "user#{n}@email.com" }
    sequence(:name) { |n| "User#{n}" }
    password '123456'
    password_confirmation '123456'
  end

  factory :user, parent: :user_unconfirmed do
    confirmed_at Time.now
  end
end
