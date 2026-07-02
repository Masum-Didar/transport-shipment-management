class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :setting_type, inclusion: { in: %w[string integer boolean json text] }

  scope :by_group, ->(group) { where(group: group) }

  def typed_value
    case setting_type
    when "integer" then value.to_i
    when "boolean" then %w[true 1 yes].include?(value.to_s.downcase)
    when "json" then JSON.parse(value)
    else value
    end
  end
end
