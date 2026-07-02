class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  validates :type, :title, presence: true

  scope :unread, -> { where(read: false) }

  def mark_as_read!
    update!(read: true, read_at: Time.current)
  end
end
