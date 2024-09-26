FactoryBot.define do
  factory :diary do
    user
    title { 'タイトル' }
    content { '内容' }
    display { true }

    trait :undisplay do
      display { false }
    end
  end
end
