FactoryBot.define do
  factory :comment do
    user
    diary
    content { 'コメント' }

  end
end
