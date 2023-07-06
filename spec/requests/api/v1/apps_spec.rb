# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Apps', type: :request do
  before { host! 'fractal-messeger.com.br' }
  let(:admin) { create(:user, :admin, name: 'Develop App') }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: admin.email, fractal_id: admin.fractal_id }) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.fractal-messeger.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => "Bearer #{token}"
    }
  end

  describe 'GET /index' do
    let!(:apps) { create_list(:app, 5) }
    before { get '/api/apps', params: {}, headers: }

    context 'successfully' do
      it 'returns status code success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a list of apps' do
        expect(json_body.count).to eq(6)
      end
    end

    context 'when the user does not have permission' do
      before { admin.remove_role(:admin) }
      before { get '/api/apps', params: {}, headers: }

      it 'returns status code unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a error message' do
        expect(json_body[:error]).to include('No Authorization!')
      end
    end
  end

  describe 'GET /show' do
    context 'successfully' do
      it 'returns status code success' do
        app = create(:app)
        get(api_v1_app_path(app), params: {}, headers:)
        expect(response).to have_http_status(:success)
      end

      it 'returns a app' do
        app = create(:app)
        get(api_v1_app_path(app), params: {}, headers:)
        expect(json_body[:name]).to eq(app.name)
      end
    end

    context 'when the app does not exist' do
      it 'returns status code 404' do
        get(api_v1_app_path(0), params: {}, headers:)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /create' do
    context 'when the parameters are valid' do
      it 'returns status code 201' do
        app = build(:app)
        post(api_v1_apps_path, params: { app: app.attributes }.to_json, headers:)
        expect(response).to have_http_status(201)
      end

      it 'returns the json for created app' do
        app = build(:app)
        post(api_v1_apps_path, params: { app: app.attributes }.to_json, headers:)
        expect(json_body[:name]).to eq(app.name)
      end
    end

    context 'when the parameters are invalid' do
      it 'returns status code 422' do
        app = build(:app, name: nil)
        post(api_v1_apps_path, params: { app: app.attributes }.to_json, headers:)
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for name' do
        app = build(:app, name: nil)
        post(api_v1_apps_path, params: { app: app.attributes }.to_json, headers:)
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /update' do
    context 'when the parameters are valid' do
      it 'returns status code 200' do
        app = create(:app)
        put(api_v1_app_path(app), params: { app: { name: 'New name' } }.to_json, headers:)
        expect(response).to have_http_status(200)
      end

      it 'returns the json for updated app' do
        app = create(:app)
        put(api_v1_app_path(app), params: { app: { name: 'New name' } }.to_json, headers:)
        expect(json_body[:name]).to eq('New name')
      end
    end

    context 'when the parameters are invalid' do
      it 'returns status code 422' do
        app = create(:app)
        put(api_v1_app_path(app), params: { app: { name: nil } }.to_json, headers:)
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for name' do
        app = create(:app)
        put(api_v1_app_path(app), params: { app: { name: nil } }.to_json, headers:)
        expect(json_body[:errors]).to have_key(:name)
      end

      it 'when the app does not exist' do
        put(api_v1_app_path(0), params: { app: { name: 'New name' } }.to_json, headers:)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when the parameters are valid' do
      it 'returns status code 204' do
        app = create(:app)
        delete(api_v1_app_path(app), params: {}, headers:)
        expect(response).to have_http_status(204)
      end

      it 'removes the app from database' do
        app = create(:app)
        delete(api_v1_app_path(app), params: {}, headers:)
        expect(App.find_by(id: app.id)).to be_nil
      end
    end

    context 'when the app does not exist' do
      it 'returns status code 404' do
        delete(api_v1_app_path(0), params: {}, headers:)
        expect(response).to have_http_status(404)
      end
    end
  end
end
