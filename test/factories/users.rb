FactoryBot.define do
  sequence(:user_email) { |n| "user#{n}@example.com" }

  factory :user do
    name { Faker::Name.name }
    email { generate(:user_email) }
    password { "password123" }
    phone { Faker::PhoneNumber.phone_number }
    status { "active" }
    association :role

    trait :super_admin do
      association :role, :super_admin
    end

    trait :admin do
      association :role, :admin
    end

    trait :dispatcher do
      association :role, :dispatcher
    end

    trait :operator do
      association :role, :operator
    end

    trait :account do
      association :role, :account
    end

    trait :viewer do
      association :role, :viewer
    end
  end
end
