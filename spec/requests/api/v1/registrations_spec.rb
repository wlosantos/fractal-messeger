# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Registrations', type: :request do
  before { host! 'fractaltecnologia.com.br' }
  let!(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let!(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }

  let(:headers) do
    {
      'Accept' => 'application/vnd.fractal-messeger.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  let(:params) do
    {
      user_application_id: 2,
      user_application_name: 'Fractal',
      datagateway_token: 'asdf-asdf-asdf-asdf',
      url: 'https://staging.datagateway.fractaltecnologia.com.br'
    }
  end

  after do
    Faraday.default_connection = nil
  end

  describe 'POST /registrations' do
    context 'failure' do
      it 'when user_application_id are invalid' do
        params[:user_application_id] = nil
        post('/api/registrations', params: params.to_json, headers:)
        expect(response).to have_http_status(401)
      end

      it 'when datagateway_token are invalid' do
        params[:datagateway_token] = nil
        post('/api/registrations', params: params.to_json, headers:)
        expect(response).to have_http_status(401)
      end

      it 'when url are nil' do
        params[:url] = nil
        post('/api/registrations', params: params.to_json, headers:)
        expect(response).to have_http_status(401)
      end

      it 'when url are invalid' do
        params[:url] = 'http://localhost:5820'
        post('/api/registrations', params: params.to_json, headers:)
        expect(response).to have_http_status(401)
      end
    end

    context 'sucessfully' do
      context 'when params are valid' do
        it 'create user' do
          decode_service = instance_double('Users::DecodeService')
          allow(Users::DecodeService).to receive(:new).and_return(decode_service)
          allow(decode_service).to receive(:call).and_return({ name: 'developer app', email: 'develop@test.com',
                                                               fractal_id: '10006', app_id: 12, dg_token: 'asdf-asdf-asdf-asdf' })
          post('/api/registrations', params: params.to_json, headers:)

          expect(response).to have_http_status(201)
          expect(json_body[:success]).to eq('Welcome! You have signed up successfully.')
          expect(User.first.name).to eq('developer app')
        end
      end

      context 'when user already exists' do
        let!(:user) { create(:user, fractal_id: '10006', email: 'develop@test.com') }

        it 'return error message' do
          decode_service = instance_double('Users::DecodeService')
          allow(Users::DecodeService).to receive(:new).and_return(decode_service)
          allow(decode_service).to receive(:call).and_return({ name: 'developer app', email: 'develop@test.com',
                                                               fractal_id: '10006' })
          post('/api/registrations', params: params.to_json, headers:)

          expect(response).to have_http_status(422)
          expect(json_body[:errors][:fractal_id]).to eq(['has already been taken'])
          expect(json_body[:errors][:email]).to eq(['has already been taken'])
        end
      end
    end
  end
end
