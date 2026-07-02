FactoryBot.define do
  factory :audit_log do
    association :user
    association :auditable, factory: :truck
    action { "create" }
    audited_changes { { "name" => [nil, "test"] } }
    ip_address { "127.0.0.1" }
    user_agent { "Rails Testing" }
  end
end
