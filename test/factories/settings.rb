FactoryBot.define do
  sequence(:setting_key) { |n| "setting_key_#{n}" }

  factory :setting do
    key { generate(:setting_key) }
    value { Faker::Lorem.sentence }
    setting_type { "string" }
    group { %w[general notification report].sample }
    description { Faker::Lorem.sentence }
  end
end
