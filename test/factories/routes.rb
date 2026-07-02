FactoryBot.define do
  factory :route do
    association :from_location, factory: :location
    association :to_location, factory: :location
    distance_km { rand(50..1500) }
    estimated_hours { rand(2..48) }

    after(:build) do |route|
      if route.from_location_id == route.to_location_id
        route.to_location = create(:location)
      end
    end
  end
end
