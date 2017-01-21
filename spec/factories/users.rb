FactoryGirl.define do
  factory :user do
    name 'example'
    email 'email@example.com'
    password '123456'
    password_confirmation '123456'
  end
end
