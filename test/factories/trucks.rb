FactoryBot.define do
  sequence(:truck_number) { |n| "TRK-#{n.to_s.rjust(4, '0')}" }

  factory :truck do
    truck_number { generate(:truck_number) }
    truck_type { %w[company outside].sample }
    status { "available" }
    brand { %w[Tata Ashok Leyland Eicher Volvo BharatBenz].sample }
    vehicle_model { Faker::Alphanumeric.alpha(number: 4).upcase }
    year { rand(2015..2024) }
    capacity_kg { [5000, 10000, 15000, 20000, 25000].sample }
    association :current_location, factory: :location

    trait :company do
      truck_type { "company" }
    end

    trait :outside do
      truck_type { "outside" }
    end

    trait :assigned do
      status { "assigned" }
    end

    trait :maintenance do
      status { "maintenance" }
    end
  end
end
