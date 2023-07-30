# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::LoginAccountService do
  describe '#call' do
    context 'create user when is not exist' do
      let(:stubs) { Faraday::Adapter::Test::Stubs.new }
      let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
      let(:token) { '123456789' }
      let(:app) { 15 }
      let(:dg_user) { { id: 1, name: 'development test', email: 'dev@test.com', fractal_id: '10006' } }

      after { Faraday.default_connection = nil }

      it 'returns a token' do
        stubs.post('/api/v1/users/check') do
          [200, {}, { id: 1, name: 'development test', email: 'test@email.com', fractal_id: '10006' }.to_json]
        end

        expect(described_class.new(token:, dg_user:, app:).call).to be_truthy
      end
    end

    context 'when token is nil' do
      it 'returns false' do
        expect(described_class.new.call).to be_falsey
      end
    end
  end
end
