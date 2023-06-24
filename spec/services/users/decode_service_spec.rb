# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::DecodeService do
  describe '#call' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }

    let(:params) do
      {
        user_application_id: 2,
        datagateway_token: 'asdf-asdf-asdf-asdf',
        url: 'https://staging.datagateway.fractaltecnologia.com.br'
      }
    end

    after do
      Faraday.default_connection = nil
    end

    context 'failure' do
      it 'when user_application_id are invalid' do
        params[:user_application_id] = nil
        expect(described_class.call(params)).to eq(false)
      end

      it 'when datagateway_token are invalid' do
        params[:datagateway_token] = nil
        expect(described_class.call(params)).to eq(false)
      end

      it 'when url are nil' do
        params[:url] = nil
        expect(described_class.call(params)).to eq(false)
      end

      it 'when url are invalid' do
        params[:url] = 'http://localhost:1880'
        expect(described_class.call(params)).to be_falsey
      end
    end

    context 'sucessfully' do
      it 'when user data is valid' do
        stubs.post('/api/v1/users/check') do
          [200, {}, { name: 'developer app', email: 'developer@email.com', fractal_id: '10006' }.to_json]
        end
        resp = described_class.call(params, conn)
        expect(resp).to eq({ name: 'developer app', email: 'developer@email.com', fractal_id: '10006' })
      end

      it 'when user data is invalid' do
        stubs.post('/api/v1/users/check') { [401, {}, { messages: 'Access Denied' }.to_json] }
        resp = described_class.call(params, conn)
        expect(resp).to eq({ messages: 'Access Denied' })
      end
    end
  end
end
