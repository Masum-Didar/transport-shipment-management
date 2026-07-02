class StatCardComponent < ViewComponent::Base
  def initialize(label:, value:, icon:, color: "text-blue-600", trend: nil, trend_up: nil)
    @label = label
    @value = value
    @icon = icon
    @color = color
    @trend = trend
    @trend_up = trend_up
  end

  def icon_bg
    case @color
    when "text-blue-600" then "bg-blue-50"
    when "text-green-600" then "bg-green-50"
    when "text-purple-600" then "bg-purple-50"
    when "text-teal-600" then "bg-teal-50"
    when "text-orange-600" then "bg-orange-50"
    when "text-red-600" then "bg-red-50"
    else "bg-gray-50"
    end
  end

  def trend_color
    @trend_up ? "text-green-600" : "text-red-500"
  end
end
