class FormFieldComponent < ViewComponent::Base
  def initialize(form:, field:, label: nil, type: :text_field, required: false, options: {})
    @form = form
    @field = field
    @label = label || field.to_s.humanize
    @type = type
    @required = required
    @options = options
  end

  def input_classes
    "block w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition disabled:bg-gray-100 disabled:cursor-not-allowed"
  end

  def call
    content_tag :div, class: "space-y-1" do
      safe_join([
        label_tag,
        input_tag,
        error_tag
      ].compact)
    end
  end

  private

  def label_tag
    label_text = @label
    label_text += " <span class='text-red-500'>*</span>" if @required
    @form.label @field, raw(label_text), class: "block text-sm font-medium text-gray-700"
  end

  def input_tag
    merged_options = { class: input_classes, required: @required }.merge(@options)
    case @type
    when :select, :collection_select
      # collection_select handled specially in view
      nil
    when :text_area
      @form.text_area @field, merged_options
    else
      @form.send(@type, @field, merged_options)
    end
  end

  def error_tag
    return unless @form.object&.errors&.key?(@field)
    content_tag :p, @form.object.errors[@field].join(", "), class: "text-xs text-red-500 mt-0.5"
  end
end
