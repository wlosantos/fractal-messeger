# frozen_string_literal: true

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      id: message.id,
      userId: message.user_id,
      fractal_id: message.user.fractal_id,
      author: message.user.name,
      content: message.content,
      createdAt: message.created_at.strftime('%d/%m/%Y %H:%M')
    }

    ActionCable.server.broadcast("messages_channel_#{message.room_id}", payload)
  end
end
