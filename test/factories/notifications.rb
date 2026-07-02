FactoryBot.define do
  factory :notification do
    association :user
    type { "shipment_created" }
    title { "New Shipment" }
    message { "A new shipment has been created." }

    trait :read do
      read { true }
      read_at { Time.current }
    end

    trait :unread do
      read { false }
      read_at { nil }
    end

    trait :with_notifiable do
      association :notifiable, factory: :shipment
    end
  end
end
