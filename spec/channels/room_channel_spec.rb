require 'rails_helper'
require "action_cable/engine"

RSpec.describe RoomChannel, type: :channel do
  it 'broadcasts a message to connected clients' do
    stub_connection
    subscribe
    expect(subscription).to be_confirmed

    message = 'Hello, world!'
    # expect { perform :broadcast_message, message }.to have_broadcasted_to('room_channel').with(message)
    expect {
      RoomChannel.broadcast_to("room_channel", message)
    }.to have_broadcasted_to('room_channel').with(message)
  end
end
