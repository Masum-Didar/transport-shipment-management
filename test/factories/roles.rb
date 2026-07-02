FactoryBot.define do
  sequence(:role_name) { |n| "role_#{n}" }

  factory :role do
    name { generate(:role_name) }
    description { Faker::Lorem.sentence }

    trait :super_admin do
      name { "super_admin" }
    end

    trait :admin do
      name { "admin" }
    end

    trait :dispatcher do
      name { "dispatcher" }
    end

    trait :operator do
      name { "operator" }
    end

    trait :account do
      name { "account" }
    end

    trait :viewer do
      name { "viewer" }
    end
  end
end
