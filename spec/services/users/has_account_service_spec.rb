# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::HasAccountService do
  describe '#call' do
    context 'when token is nil' do
      it 'returns false' do
        expect(described_class.new.call).to be_falsey
      end
    end

    context 'when token is not nil' do
      let(:user) { create(:user) }
      let(:token) { user.dg_token }

      it 'returns a token' do
        expect(described_class.new(token).call).to be_truthy
      end
    end
  end
end
