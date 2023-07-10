# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Rooms API' do
  before { host! 'fractal-messeger.com.br' }
  before { @app = create(:app) }
  before { @user = create(:user, app: @app) }
  let(:admin) { create(:user, :admin, name: 'Wendel Lopes', app: @app) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: admin.email, fractal_id: admin.fractal_id }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.fractal-messeger.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  # list all rooms
  path '/api/apps/{id}/rooms' do
    get 'List all rooms' do
      tags 'Rooms'
      security [Bearer: []]
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'App ID'

      response '200', 'List all rooms' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer, example: 1 },
                   name: { type: :string, example: 'Room 1' },
                   kind: { type: :string, example: 'public' },
                   create_by: { type: :string, example: 'Wendel Lopes' },
                   read_only: { type: :boolean, example: false },
                   moderated: { type: :boolean, example: false },
                   app: { type: :string, example: 'Fractal' },
                   status: { type: :string, example: 'open' },
                   moderators: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer, example: 1 },
                         name: { type: :string, example: 'Wendel Lopes' }
                       },
                       required: %w[userId name]
                     }
                   },
                   participants: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         RoomParticipantId: { type: :integer, example: 1 },
                         userId: { type: :integer, example: 1 },
                         name: { type: :string, example: 'Wendel Lopes' },
                         moderator: { type: :boolean, example: true },
                         blocked: { type: :boolean, example: false }
                       },
                       required: %w[RoomParticipantId userId name moderator blocked]
                     }
                   }
                 },
                 required: %w[id name kind create_by read_only moderated app status moderators participants]
               }

        let(:id) { @app.id }
        let(:Authorization) { "Bearer #{token}" }
        before { create_list(:room, 5, app: @app) }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { @app.id }
        let(:Authorization) { nil }
        run_test!
      end

      response '404', 'App not found' do
        let(:id) { 0 }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  # show room
  path '/api/rooms/{id}' do
    get 'Show selected room' do
      tags 'Rooms'
      security [Bearer: []]
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Room ID'
      response '200', 'Show selected room' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 name: { type: :string, example: 'Room 1' },
                 kind: { type: :string, example: 'groups' },
                 create_by: { type: :string, example: 'Wendel Lopes' },
                 read_only: { type: :boolean, example: false },
                 moderated: { type: :boolean, example: false },
                 app: { type: :string, example: 'Fractal' },
                 status: { type: :string, example: 'open' },
                 moderators: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       name: { type: :string, example: 'Wendel Lopes' }
                     },
                     required: %w[userId name]
                   }
                 },
                 participants: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       RoomParticipantId: { type: :integer, example: 1 },
                       userId: { type: :integer, example: 1 },
                       name: { type: :string, example: 'Wendel Lopes' },
                       moderator: { type: :boolean, example: false },
                       blocked: { type: :boolean, example: false }
                     },
                     required: %w[RoomParticipantId userId name moderator blocked]
                   }
                 },
                 messages: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       userId: { type: :integer, example: 1 },
                       author: { type: :string, example: 'Wendel Lopes' },
                       content: { type: :string, example: 'Hello World' },
                       createdAt: { type: :string, example: '2020-10-10T00:00:00.000Z' }
                     },
                     required: %w[id userId author content createdAt]
                   }
                 }
               },
               required: %w[id name kind create_by read_only moderated app status moderators participants messages]

        let(:Authorization) { "Bearer #{token}" }
        before { @room = create(:room, app: @app, create_by: admin) }
        let(:id) { @room.id }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:room, app: @app, create_by: admin).id }
        let(:Authorization) { nil }
        run_test!
      end

      response '404', 'Room not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  # create room
  path '/api/apps/{id}/rooms' do
    post 'Create a room' do
      tags 'Rooms'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'App ID'
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          room: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Room 1' },
              kind: { type: :string, example: 'privates' },
              read_only: { type: :boolean, example: false },
              moderated: { type: :boolean, example: false },
              closed: { type: :boolean, example: false }
            },
            required: %w[name kind read_only moderated closed]
          }
        },
        required: %w[room]
      }, required: true

      response '201', 'Room created' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 name: { type: :string, example: 'Room 1' },
                 kind: { type: :string, example: 'privates' },
                 create_by: { type: :string, example: 'Wendel Lopes' },
                 read_only: { type: :boolean, example: false },
                 moderated: { type: :boolean, example: false },
                 app: { type: :string, example: 'Fractal' },
                 status: { type: :string, example: 'open' },
                 moderators: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       name: { type: :string, example: 'Wendel Lopes' }
                     },
                     required: %w[userId name]
                   }
                 },
                 participants: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       RoomParticipantId: { type: :integer, example: 1 },
                       userId: { type: :integer, example: 1 },
                       name: { type: :string, example: 'Wendel Lopes' },
                       moderator: { type: :boolean, example: false },
                       blocked: { type: :boolean, example: false }
                     },
                     required: %w[RoomParticipantId userId name moderator blocked]
                   }
                 }
               },
               required: %w[id name kind create_by read_only moderated app status moderators participants]

        let(:Authorization) { "Bearer #{token}" }
        let(:id) { @app.id }
        let(:room) { { room: attributes_for(:room, app: @app, create_by: admin) } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:app).id }
        let(:room) { { room: attributes_for(:room, app: @app, create_by: admin) } }
        let(:Authorization) { nil }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:id) { @app.id }
        let(:room) { { room: { name: nil } } }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  # update room
  path '/api/rooms/{id}' do
    put 'Update a room' do
      tags 'Rooms'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Room ID'
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          room: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Room 1' },
              kind: { type: :string, example: 'privates' },
              read_only: { type: :boolean, example: false },
              moderated: { type: :boolean, example: false }
            },
            required: %w[name kind read_only moderated closed]
          }
        },
        required: %w[room]
      }, required: true

      response '200', 'Room updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 name: { type: :string, example: 'Room 1' },
                 kind: { type: :string, example: 'privates' },
                 create_by: { type: :string, example: 'Wendel Lopes' },
                 read_only: { type: :boolean, example: false },
                 moderated: { type: :boolean, example: false },
                 app: { type: :string, example: 'Fractal' },
                 status: { type: :string, example: 'open' },
                 moderators: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       name: { type: :string, example: 'Wendel Lopes' }
                     },
                     required: %w[userId name]
                   }
                 },
                 participants: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       RoomParticipantId: { type: :integer, example: 1 },
                       userId: { type: :integer, example: 1 },
                       name: { type: :string, example: 'Wendel Lopes' },
                       moderator: { type: :boolean, example: false },
                       blocked: { type: :boolean, example: false }
                     },
                     required: %w[RoomParticipantId userId name moderator blocked]
                   }
                 }
               },
               required: %w[id name kind create_by read_only moderated app status moderators participants]

        let(:Authorization) { "Bearer #{token}" }
        before { @room = create(:room, app: @app, create_by: admin) }
        let(:id) { @room.id }
        let(:room) { { room: attributes_for(:room, app: @app, create_by: admin) } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:room, app: @app, create_by: admin).id }
        let(:room) { { room: attributes_for(:room, app: @app, create_by: admin) } }
        let(:Authorization) { nil }
        run_test!
      end

      response '404', 'Invalid request' do
        let(:id) { @app.id }
        let(:room) { { room: { name: nil } } }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  # delete room
  path '/api/rooms/{id}' do
    delete 'Delete a room' do
      tags 'Rooms'
      security [Bearer: {}]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Room ID'

      response '204', 'Room deleted' do
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { create(:room, app: @app, create_by: admin).id }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:room, app: @app, create_by: admin).id }
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  # add participant
  path '/api/rooms/{id}/participants' do
    post 'Add participant to a room' do
      tags 'Rooms'
      security [Bearer: {}]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Room ID'
      parameter name: :participant, in: :body, schema: {
        type: :object,
        properties: {
          room_participant: {
            type: :object,
            properties: {
              user_id: { type: :integer, example: 1 },
              is_blocked: { type: :boolean, example: false }
            },
            required: %w[user_id is_blocked]
          }
        },
        required: %w[room_participant]
      }, required: true

      response '201', 'Participant added' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 user_id: { type: :integer, example: 1 },
                 room_id: { type: :integer, example: 1 },
                 is_blocked: { type: :boolean, example: false },
                 created_at: { type: :string, example: '2020-01-01T00:00:00.000Z' },
                 updated_at: { type: :string, example: '2020-01-01T00:00:00.000Z' }
               },
               required: %w[id is_blocked user_id room_id created_at updated_at]

        let(:Authorization) { "Bearer #{token}" }
        before { @room = create(:room, app: @app, create_by: admin) }
        let(:id) { @room.id }
        let(:participant) { { room_participant: { user_id: @user.id, is_blocked: false } } }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:room, app: @app, create_by: admin).id }
        let(:participant) { { room_participant: { user_id: @user.id, is_blocked: false } } }
        let(:Authorization) { nil }
        run_test!
      end

      response '404', 'Invalid request' do
        let(:id) { @app.id }
        let(:participant) { { room_participant: { user_id: @user.id, is_blocked: false } } }
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  # remove participant
  path '/api/rooms/{id}/participants/{participant_id}' do
    delete 'Remove participant from a room' do
      tags 'Rooms'
      security [Bearer: {}]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Room ID'
      parameter name: :participant_id, in: :path, type: :string, required: true, description: 'Participant ID'

      response '204', 'Participant removed' do
        let(:Authorization) { "Bearer #{token}" }
        before { @room = create(:room, app: @app, create_by: admin) }
        let(:id) { @room.id }
        let(:participant_id) { @room.room_participants.first.id }
        run_test!
      end
    end
  end

  # block participant
  path '/api/rooms/{id}/participants/{participant_id}' do
    put 'Block or unblocked participant from a room' do
      tags 'Rooms'
      security [Bearer: {}]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Room ID'
      parameter name: :participant_id, in: :path, type: :string, required: true, description: 'Participant ID'

      response '200', 'blocked or unblocked Participant' do
        let(:Authorization) { "Bearer #{token}" }
        before { @room = create(:room, app: @app, create_by: admin) }
        let(:id) { @room.id }
        let(:participant_id) { @room.room_participants.first.id }
        run_test!
      end

      response '401', 'Unauthorized' do
        before { @room = create(:room, app: @app, create_by: admin) }
        let(:id) { @room.id }
        let(:participant_id) { create(:room_participant, room: @room).id }
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  # add moderator participant
  path '/api/rooms/{id}/moderators/{participant_id}' do
    put 'Add moderator participant to a room' do
      tags 'Rooms'
      security [Bearer: {}]

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, description: 'Room ID'
      parameter name: :participant_id, in: :path, type: :string, required: true, description: 'Participant ID'

      response '200', 'Participant added as moderator' do
        let(:Authorization) { "Bearer #{token}" }
        before { @room = create(:room, app: @app, create_by: admin) }
        let(:id) { @room.id }
        let(:participant_id) { @room.room_participants.first.id }
        run_test!
      end
    end
  end
end
