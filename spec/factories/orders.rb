FactoryBot.define do
  factory :order do
    user
    cash_on_delivery { 330 }
    shipping_fee { 660 }
    schedule_date { 3.business_days.from_now.to_date }
    schedule_time { 1 }
  end
end
