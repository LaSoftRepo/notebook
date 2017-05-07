FactoryGirl.define do
  factory :notice do
    name { Faker::Lorem.word }
    text { Faker::Lorem.sentence }
    association :section, factory: :section
  end

  factory :invalid_notice, parent: :notice do
    name nil
  end
end
