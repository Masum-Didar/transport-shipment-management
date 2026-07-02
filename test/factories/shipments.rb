FactoryBot.define do
  sequence(:shipment_number) { |n| "SH-#{Date.current.strftime("%Y%m%d")}-#{n.to_s.rjust(4, '0')}" }

  factory :shipment do
    shipment_number
    shipment_type { %w[import export].sample }
    status { "pending" }
    shipment_date { Date.current }
    association :source_location, factory: :location
    association :destination_location, factory: :location
    association :created_by, factory: :user
    association :route, factory: :route
    association :truck, factory: :truck

    trait :import do
      shipment_type { "import" }
    end

    trait :export do
      shipment_type { "export" }
    end

    trait :loading do
      status { "loading" }
    end

    trait :loaded do
      status { "loaded" }
    end

    trait :on_the_way do
      status { "on_the_way" }
    end

    trait :reached do
      status { "reached" }
    end

    trait :unloading do
      status { "unloading" }
    end

    trait :completed do
      status { "completed" }
      actual_delivery_date { Time.current }
    end

    trait :with_items do
      after(:create) do |shipment|
        create_list(:shipment_item, 2, shipment: shipment)
      end
    end
  end
end
