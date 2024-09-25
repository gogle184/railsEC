FactoryBot.define do
  factory :product do
    sequence(:name) { "Product_#{_1}" }
    price { 1000 }
    description { 'テスト説明文' }
    display { true }

    trait :undisplay do
      display { false }
    end
  end
end
