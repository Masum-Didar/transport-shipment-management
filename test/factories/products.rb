FactoryBot.define do
  sequence(:product_name) { |n| "Product #{n}" }

  factory :product do
    name { generate(:product_name) }
    description { Faker::Lorem.sentence }
    default_unit { %w[kg ton piece bag drum crate].sample }
    association :product_category

    trait :with_category do
      association :product_category
    end
  end
end
