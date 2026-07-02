FactoryBot.define do
  factory :shipment_status_log do
    association :shipment
    association :changed_by, factory: :user
    status { "pending" }
    changed_at { Time.current }
  end
end
