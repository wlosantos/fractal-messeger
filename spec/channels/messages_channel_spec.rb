# frozen_string_literal: true

require 'rails_helper'
require 'action_cable/engine'

RSpec.describe MessagesChannel, type: :channel do
  let!(:user) { create(:user) }
  let!(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email, fractal_id: user.fractal_id }) }
  let!(:room) { create(:room, create_by: user) }
  let!(:message) { create(:message, user:, room:) }

  it 'broadcasts a message to connected clients' do
    stub_connection
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('messages_channel')
  end
end
