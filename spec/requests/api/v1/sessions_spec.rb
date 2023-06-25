# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  before { host! 'fractaltecnologia.com.br' }

  describe 'POST /sessions' do
    let(:user) { create(:user, :admin) }

    context 'when the credentials is correct' do
      before do
        post '/api/sessions', params: { email: user.email, fractal_id: user.fractal_id }
      end

      let(:token) { JSON.parse(response.body)['token'] }

      it 'returns a JWT token' do
        expect(token).not_to be_nil
      end
    end

    context 'when the credentials is incorrect' do
      before do
        post '/api/sessions', params: { email: user.email, fractal_id: 'wrong_fractal_id' }
      end

      it 'returns unauthorized access' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(response.body).to match(/Invalid credentials/)
      end
    end

    context 'when the credentials is empty' do
      before do
        post '/api/sessions', params: { email: '', fractal_id: '' }
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(response.body).to match(/Invalid credentials/)
      end
    end
  end
end
