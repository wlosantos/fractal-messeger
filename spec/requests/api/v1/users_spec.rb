# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Api', type: :request do
  before { host! 'messenger-fractal.com.br' }
  let(:admin) { create(:user, :admin) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: admin.email, fractal_id: admin.fractal_id }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.messenger-fractal.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /users' do
    context 'successfully' do
      before do
        get '/api/users', params: {}, headers:
      end

      it 'returns users' do
        expect(json_body[:name]).to eq(admin.name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'failure - token is errors' do
      before do
        get '/api/users', params: {}, headers: {}
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'failure - token is nil' do
      before do
        get '/api/users', params: {}, headers: nil
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'failure - token is empty' do
      before do
        get '/api/users', params: {}, headers: {}
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
