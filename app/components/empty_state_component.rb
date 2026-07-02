class EmptyStateComponent < ViewComponent::Base
  def initialize(icon:, title:, description: nil, action: nil)
    @icon = icon
    @title = title
    @description = description
    @action = action
  end
end
