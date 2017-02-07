FactoryGirl.define do
  factory :notebook do
    name { Faker::Lorem.word }
    association :user, factory: :user
  end
end
