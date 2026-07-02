class ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary:   "bg-blue-600 text-white hover:bg-blue-700 shadow-sm",
    secondary: "bg-white border border-gray-300 text-gray-700 hover:bg-gray-50",
    danger:    "bg-red-600 text-white hover:bg-red-700 shadow-sm",
    ghost:     "text-gray-600 hover:bg-gray-100"
  }

  SIZES = {
    sm:  "px-3 py-1.5 text-xs",
    md:  "px-4 py-2 text-sm",
    lg:  "px-6 py-3 text-base"
  }

  def initialize(label:, variant: :primary, size: :md, icon: nil, href: nil, options: {})
    @label = label
    @variant = variant
    @size = size
    @icon = icon
    @href = href
    @options = options
  end

  def classes
    "inline-flex items-center gap-2 rounded-lg font-medium transition-colors #{VARIANTS[@variant]} #{SIZES[@size]}"
  end

  def call
    if @href
      link_to @href, class: classes, **@options do
        safe_join([icon_tag, @label].compact)
      end
    else
      content_tag :button, class: classes, **@options do
        safe_join([icon_tag, @label].compact)
      end
    end
  end

  private

  def icon_tag
    return unless @icon
    content_tag :span, @icon, class: "flex-shrink-0"
  end
end
