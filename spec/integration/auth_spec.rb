# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Auth API' do
  let!(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let!(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:account) { create(:user) }

  let(:headers) do
    {
      'Accept' => 'application/vnd.messeger-fractal.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  after do
    Faraday.default_connection = nil
  end

  path '/api/sessions' do
    post 'Creates a session' do
      tags 'Auth - Sessions'
      security [Bearer: []]

      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user_application_id: { type: :integer, exemple: 2 },
          token: { type: :string, exemple: 'b30c50a18d-40eccaae91-1685622812' }
        },
        required: %w[user_application_id token]
      }, required: true

      response '200', 'Session created' do
        schema type: :object,
               properties: {
                 token: { type: :string, exemple: 'asdf-asdf-asdf-asdf-asdf' }
               },
               required: %w[token]

        let(:Authorization) { '' }
        let(:params) { { user_application_id: 2, token: 'b30c50a18d-40eccaae91-1685622812' } }
        let(:token) { JwtAuth::TokenProvider.issue_token({ email: admin.email, fractal_id: admin.fractal_id }) }
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:Authorization) { '' }
        let(:params) { { user_application_id: 2, token: nil } }
        run_test!
      end
    end
  end
end
