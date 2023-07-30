# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::DgAppService do
  describe '#call' do
    context 'when token is nil' do
      it { expect(described_class.new(token: nil, app: 10).call).to have_key(:error) }
      it { expect(described_class.new(token: nil, app: 10).call).to include(error: 'No token') }
    end

    context 'when token is not nil' do
      let(:user) { create(:user) }
      let(:token) { user.dg_token }

      it 'returns a token' do
        expect(described_class.new(token:, app: 30).call).to be_truthy
      end
    end
  end
end
