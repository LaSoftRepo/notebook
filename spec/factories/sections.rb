FactoryGirl.define do
  factory :section do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    association :notebook, factory: :notebook
  end

  factory :invalid_section, parent: :section do
    name nil
  end
end
