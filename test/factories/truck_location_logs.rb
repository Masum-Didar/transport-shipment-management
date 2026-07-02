FactoryBot.define do
  factory :truck_location_log do
    association :truck
    association :updated_by, factory: :user
    location { Faker::Address.city }
    logged_at { Time.current }
  end
end
