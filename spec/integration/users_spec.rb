# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'User API' do
  before { host! 'fractal-messeger.com.br' }
  before { @app = create(:app) }
  let(:user) { create(:user, :admin, name: 'Wendel Lopes', app: @app) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email, fractal_id: user.fractal_id }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.fractal-messeger.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  path '/api/users' do
    get 'User data' do
      tags 'Users'
      security [Bearer: {}]

      response '200', 'User data' do
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 name: { type: :string, example: 'Wendel Lopes' },
                 email: { type: :string, example: 'wendel@email.com' },
                 fractal_id: { type: :string, example: '123456789' },
                 app_id: { type: :integer, example: 1 },
                 roles: { type: :array, items: { type: :string, example: 'admin' } }
               },
               required: %w[id name email fractal_id app_id roles]

        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { '' }
        run_test!
      end
    end
  end
end
