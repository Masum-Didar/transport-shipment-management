FactoryBot.define do
  sequence(:category_name) { |n| "Category #{n}" }

  factory :product_category do
    name { generate(:category_name) }
    description { Faker::Lorem.sentence }
  end
end
