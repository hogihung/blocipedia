# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "playTime"
    password_confirmation "playTime"

    trait :premium do
      role "premium"
    end

    trait :with_post do
      after(:create) do |user, eval|
        FactoryGirl.create(:wiki, user: user )
      end
    end

    factory :admin_user do
      role "admin"
    end

    confirmed_at Time.now
  end
end
