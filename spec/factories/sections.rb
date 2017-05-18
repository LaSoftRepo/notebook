FactoryGirl.define do
  factory :section do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    association :notebook, factory: :notebook

    trait :child do
      association :parent_section, factory: :section
    end
  end

  factory :invalid_section, parent: :section do
    name nil
  end
end
