FactoryGirl.define do
  factory :notebook do
    name { Faker::Lorem.word }
    association :user, factory: :user
  end

  factory :invalid_notebook, parent: :notebook do
    name nil
  end
end
