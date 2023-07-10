# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :parent, class_name: 'Message', optional: true, foreign_key: 'parent_id'
  belongs_to :moderator, class_name: 'User', optional: true, foreign_key: 'moderator_id'

  enum status_moderation: { blank: 0, pending: 1, approved: 2, refused: 3 }

  validates :content, presence: true, length: { maximum: 240 }
  validate :message_permitted, on: %i[create]

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  def message_permitted
    user_blocked_send_message
    user_is_participant
    room_closed
  end

  private

  def user_blocked_send_message
    return unless room.room_participants.exists? || !room.room_participants.nil?

    return unless room.room_participants.where(user_id: user.id, is_blocked: true).present?

    errors.add(:user_id, 'is blocked to send message')
  end

  def user_is_participant
    return unless room.room_participants.where(user_id: user.id).blank?

    errors.add(:user_id, 'is not participant')
  end

  def room_closed
    return unless room.closed?

    errors.add(:room_id, 'is closed')
  end
end
