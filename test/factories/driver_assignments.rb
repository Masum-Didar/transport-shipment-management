FactoryBot.define do
  factory :driver_assignment do
    association :driver
    association :truck
    association :assigned_by, factory: :user
    assigned_at { Time.current }

    trait :released do
      released_at { Time.current + rand(1..24).hours }
    end
  end
end
