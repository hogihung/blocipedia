# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "playTime"
    password_confirmation "playTime"

    confirmed_at Time.now
  end
end
