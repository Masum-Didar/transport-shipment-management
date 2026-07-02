class ModalComponent < ViewComponent::Base
  def initialize(title:, message:, confirm_path:, confirm_method: :delete, confirm_text: "Confirm", cancel_text: "Cancel", icon: "⚠️")
    @title = title
    @message = message
    @confirm_path = confirm_path
    @confirm_method = confirm_method
    @confirm_text = confirm_text
    @cancel_text = cancel_text
    @icon = icon
  end
end
