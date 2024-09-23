FactoryBot.define do
  factory :order_item do
    product
    order
  end
end
