# frozen_string_literal: true

require 'rails_helper'
require 'action_cable/engine'

RSpec.describe MessagesChannel, type: :channel do
  let!(:user) { create(:user) }
  let!(:room) { create(:room, create_by: user) }
  let!(:room_participant) { create(:room_participant, room:, user:) }
  let(:message) { create(:message, user:, room:) }

  it 'broadcasts a message to connected clients' do
    stub_connection
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('messages_channel')

    payload = {
      id: message.id,
      userId: message.user_id,
      author: message.user.name,
      content: message.content,
      createdAt: message.created_at.strftime('%d/%m/%Y %H:%M')
    }

    expect do
      MessagesChannel.broadcast_to('messages_channel', payload)
    end.to have_broadcasted_to('messages_channel').with(payload)
  end
end
