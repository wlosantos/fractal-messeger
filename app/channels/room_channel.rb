class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stop_all_streams
    # room = Room.find(params[:room_id])
    # stream_for room
    stream_from "room_channel"
  end

  def speak(data)
    puts "this is a data: #{data}"
  end

  def unsubscribed
    # stop_all_streams
  end
end
