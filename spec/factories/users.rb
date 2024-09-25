FactoryBot.define do
  factory :user do
    sequence(:display_name) { |n| "user#{n}" }
    sequence(:name) { |n| "田中#{n}郎" }
    sequence(:email) { |n| "user#{n}@example.com" }
    phone_number { '00011112222' }
    postal_code { '0001111' }
    address { 'H県H市' }
    password { 'password' }
  end
end
