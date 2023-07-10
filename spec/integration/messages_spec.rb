# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Messages API' do
  before { host! 'fractal-messeger.com.br' }
  before { @app = create(:app) }
  before { @room = create(:room, app: @app) }
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', app: @app) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email, fractal_id: user.fractal_id }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.fractal-messeger.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  # create message
  path '/api/rooms/{id}/messages' do
    post 'Create message' do
      tags 'Messages'
      security [Bearer: {}]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :message, in: :body, schema: {
        type: :object,
        properties: {
          message: {
            type: :object,
            properties: {
              content: { type: :string, example: 'Hello World!' },
              status_modeator: { type: :string, example: 'blank' },
              moderated_at: { type: :string, example: nil },
              refused_at: { type: :string, example: nil },
              parent_id: { type: :integer, example: nil }
            },
            required: %w[content status_moderator moderated_at refused_at parent_id]
          }
        },
        required: %w[message]
      }, required: true, description: 'Message params'

      response '201', 'message created' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 content: { type: :string, example: 'Hello World!' },
                 status_moderation: { type: :string, example: 'blank' },
                 created_at: { type: :string, example: '2020-10-10T00:00:00.000Z' },
                 updated_at: { type: :string, example: '2020-10-10T00:00:00.000Z' },
                 user_id: { type: :integer, example: 1 },
                 room_id: { type: :integer, example: 1 }
               },
               required: %w[id content status_moderation user_id room_id created_at updated_at author]

        let(:Authorization) { headers['Authorization'] }
        let!(:room_participant) { create(:room_participant, room: @room, user:) }
        let(:id) { @room.id }
        let(:message) do
          { message: { content: 'Hello World!', status_moderator: 'blank', moderated_at: nil, refused_at: nil, parent_id: nil } }
        end
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:id) { @room.id }
        let(:message) do
          { message: { content: 'Hello World!', status_moderator: 'blank', moderated_at: nil, refused_at: nil, parent_id: nil } }
        end
        run_test!
      end

      response '404', 'room not found' do
        schema type: :object,
               properties: {
                 errors: { type: :string, example: 'Room dont exist, closed, or is read only' }
               },
               required: %w[errors]
        let(:Authorization) { headers['Authorization'] }
        let(:id) { 0 }
        let(:message) do
          { message: { content: 'Hello World!', status_moderator: 'blank', moderated_at: nil, refused_at: nil, parent_id: nil } }
        end
        run_test!
      end
    end
  end

  # destroy message
  path '/api/messages/{id}' do
    delete 'Destroy message' do
      tags 'Messages'
      security [Bearer: {}]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '204', 'message destroyed' do
        let(:Authorization) { headers['Authorization'] }
        let!(:room_participant) { create(:room_participant, room: @room, user:) }
        let(:id) { create(:message, user:, room: @room).id }
        run_test!
      end
    end
  end
end
