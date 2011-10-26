FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
  end

  factory :deal do
    title       'New Deal'
    price       25
    url         'http://amazon.com'
    description 'Text that is long enough'
    user
  end

  factory :vote do
    deal
    user
  end
end
