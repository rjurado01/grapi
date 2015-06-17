FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:text) { |n| "Text #{n}" }
    user_id { FactoryGirl.create(:user).id }
  end
end
