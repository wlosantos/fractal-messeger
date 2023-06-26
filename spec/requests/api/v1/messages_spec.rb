# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Messages', type: :request do
  before { host! 'messeger-fractal.com.br' }
  before { @room = create(:room) }
  let(:admin) { create(:user, :admin, name: 'Reginaldo Perine') }
  let!(:participant) { create(:room_participant, room: @room, user: admin) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: admin.email, fractal_id: admin.fractal_id }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.messeger-fractal.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'POST /create' do
    context 'when the params are valid' do
      before { post "/api/rooms/#{@room.id}/messages", params: { message: message_params }.to_json, headers: }
      let(:message_params) { build(:message, room_id: @room.id) }

      it 'returns status code created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the json data for the created message' do
        expect(json_body[:content]).to eq(message_params[:content])
      end
    end

    context 'when room does not exist' do
      before { post '/api/rooms/0/messages', params: { message: message_params }.to_json, headers: }
      let(:message_params) { build(:message) }

      it 'returns status code not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the json data for the errors' do
        expect(json_body[:errors]).to include('Room not found')
      end
    end
  end

  describe 'PUT /update' do
    let!(:message) { create(:message, room_id: @room.id, user: participant.user) }
    before { put "/api/messages/#{message.id}", params: { message: message_params }.to_json, headers: }

    context 'when the params are valid' do
      let(:message_params) { { content: 'Olá, tudo bem?' } }

      it 'returns status code ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the json data for the updated message' do
        expect(json_body[:content]).to eq(message_params[:content])
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:message) { create(:message, room_id: @room.id, user: participant.user) }
    before { delete "/api/messages/#{message.id}", params: {}, headers: }

    it 'returns status code no_content' do
      expect(response).to have_http_status(:no_content)
    end

    it 'removes the message from database' do
      expect { Message.find(message.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
