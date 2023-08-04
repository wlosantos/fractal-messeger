# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  before { host! 'fractaltecnologia.com.br' }

  describe 'POST /sessions' do
    context 'when account exists' do
      context 'successfully' do
        let!(:account) { create(:user) }
        let(:token) { JwtAuth::TokenProvider.issue_token({ email: account.email, fractal_id: account.fractal_id }) }

        before do
          post '/api/sessions', params: { token: account.dg_token, user_application_id: account.app_id }
        end

        it 'returns a JWT token' do
          expect(JSON.parse(response.body)['token']).not_to be_nil
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns Authorization header' do
          expect(response.headers['Authorization']).not_to be_nil
        end
      end
    end

    context 'when message account does not exist' do
      context 'when user dg exist' do
        let(:stubs) { Faraday::Adapter::Test::Stubs.new }
        let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }

        let(:params) do
          {
            token: '123456789',
            user_application_id: 30
          }
        end

        after do
          Faraday.default_connection = nil
        end

        it 'when user dg does not exist' do
          params[:token] = nil
          stubs.post('/api/v1/users/check') do
            [401, {}, { error: 'User not found' }.to_json]
          end

          post('/api/sessions', params:)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
