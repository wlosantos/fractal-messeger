# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Auth API' do
  let(:account) { create(:user) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: account.email, fractal_id: account.fractal_id }) }

  let(:headers) do
    {
      'Accept' => 'application/vnd.messeger-fractal.v1',
      'Content-Type' => Mime[:json].to_s
    }
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
        let(:params) { { user_application_id: account.app_id, token: account.dg_token } }
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
