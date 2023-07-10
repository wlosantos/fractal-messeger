# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Auth API' do
  let!(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let!(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:account) { create(:user, :admin) }

  let(:headers) do
    {
      'Accept' => 'application/vnd.messeger-fractal.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  let(:params) do
    {
      user_application_id: 2,
      user_application_name: 'Bertoni',
      datagateway_token: 'b30c50a18d-40eccaae91-1685622812',
      url: 'https://staging.datagateway.fractaltecnologia.com.br'
    }
  end

  before do
    decode_service = instance_double('Users::DecodeService')
    allow(Users::DecodeService).to receive(:new).and_return(decode_service)
    allow(decode_service).to receive(:call).and_return({ name: 'developer app', email: 'develop@test.com', fractal_id: '10006' })
  end

  after do
    Faraday.default_connection = nil
  end

  path '/api/registrations' do
    post 'Create a new user' do
      tags 'Auth - Registrations'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user_application_id: { type: :integer, example: 2 },
          user_application_name: { type: :string, example: 'Bertoni' },
          datagateway_token: { type: :string, example: 'b30c50a18d-40eccaae91-1685622812' },
          url: { type: :string, example: 'https://staging.datagateway.fractaltecnologia.com.br' }
        }
      }

      response '201', 'User created' do
        let(:Authorization) { '' }

        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { '' }
        before do
          decode_service = instance_double('Users::DecodeService')
          allow(Users::DecodeService).to receive(:new).and_return(decode_service)
          allow(decode_service).to receive(:call).and_return({ name: 'developer app', email: nil, fractal_id: '10006' })
        end

        run_test!
      end
    end
  end

  path '/api/sessions' do
    post 'Creates a session' do
      tags 'Auth - Sessions'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'wendel.lopes@fractaltecnologia.com.br' },
          fractal_id: { type: :string, example: '10006' }
        },
        required: %w[email fractal_id]
      }

      response '200', 'Session created' do
        schema type: :object,
               properties: {
                 token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9' }
               }

        let(:Authorization) { '' }
        let(:user) { { email: account.email, fractal_id: account.fractal_id } }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:Authorization) { '' }
        let(:user) { { email: account.email, fractal_id: 'wrong_fractal_id' } }
        run_test!
      end
    end
  end
end
