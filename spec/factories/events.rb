FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    association :category
  end
end
