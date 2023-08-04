# frozen_string_literal: true

class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    room = Room.find(params[:room_id])
    if user_can_participate_in_conversation?(room)
      stream_from "messages_channel_#{params[:room_id]}"
    else
      reject_unauthorized_connection
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def user_can_participate_in_conversation?(room)
    room.room_participants.find_by(user_id: current_user.id)
  end
end
