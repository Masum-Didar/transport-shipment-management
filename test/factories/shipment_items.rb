FactoryBot.define do
  factory :shipment_item do
    association :shipment
    association :product
    quantity { rand(10..1000) }
    unit { %w[kg ton piece bag drum crate].sample }
  end
end
