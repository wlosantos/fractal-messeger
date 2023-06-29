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
    let(:user) { create(:user) }
    let(:participant) { create(:room_participant, room: @room, user:) }
    let(:token) { JwtAuth::TokenProvider.issue_token({ email: participant.user.email, fractal_id: participant.user.fractal_id }) }

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
      let(:user) { create(:user) }
      before { post '/api/rooms/0/messages', params: { message: message_params }.to_json, headers: }
      let(:message_params) { build(:message) }

      it 'returns status code not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the json data for the errors' do
        expect(json_body[:errors]).to include('Room dont exist, closed, or is read only')
      end
    end

    context 'when user is not a participant' do
      let(:participant) { create(:room_participant) }
      before { post "/api/rooms/#{@room.id}/messages", params: { message: message_params }.to_json, headers: }
      let(:message_params) { build(:message) }

      it 'returns status code unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns message errors' do
        expect(json_body[:errors][:user_id][0]).to include('is not participant')
      end
    end

    context 'when the room is read_only' do
      let(:room) { create(:room, read_only: true) }
      let(:participant) { create(:room_participant, room:, user:) }
      before { post "/api/rooms/#{room.id}/messages", params: { message: message_params }.to_json, headers: }
      let(:message_params) { build(:message) }

      it 'returns status code unprocessable_entity' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns message errors' do
        expect(json_body[:errors]).to include('Room dont exist, closed, or is read only')
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:user) { create(:user) }
    let(:participant) { create(:room_participant, room: @room, user:) }
    let(:token) { JwtAuth::TokenProvider.issue_token({ email: participant.user.email, fractal_id: participant.user.fractal_id }) }

    context 'when the params are valid' do
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
end
