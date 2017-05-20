FactoryGirl.define do
  factory :section do
    name { Faker::Lorem.word }
    association :notebook, factory: :notebook

    trait :child do
      association :parent_section, factory: :section
    end
  end

  factory :invalid_section, parent: :section do
    name nil

    trait :child do
      name nil
      association :parent_section, factory: :section
    end
  end
end
