FactoryBot.define do
  sequence(:location_name) { |n| "Location #{n}" }

  factory :location do
    name { generate(:location_name) }
    location_type { %w[port icd warehouse factory border other].sample }
    address { Faker::Address.full_address }
    city { Faker::Address.city }
    country { "Bangladesh" }
    division { Faker::Address.state }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    notes { Faker::Lorem.sentence }

    trait :port do
      location_type { "port" }
    end

    trait :warehouse do
      location_type { "warehouse" }
    end

    trait :factory do
      location_type { "factory" }
    end
  end
end
