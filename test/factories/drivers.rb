FactoryBot.define do
  sequence(:driver_phone) { |n| "+8801#{n.to_s.rjust(9, '0')}" }
  sequence(:driver_license) { |n| "LIC-#{n.to_s.rjust(8, '0')}" }

  factory :driver do
    name { Faker::Name.name }
    phone { generate(:driver_phone) }
    alternative_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    address { Faker::Address.full_address }
    license_number { generate(:driver_license) }
    status { "available" }

    trait :driving do
      status { "driving" }
    end

    trait :leave do
      status { "leave" }
    end

    trait :inactive do
      status { "inactive" }
    end
  end
end
