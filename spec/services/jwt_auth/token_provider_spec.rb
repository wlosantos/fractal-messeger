# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuth::TokenProvider, type: :service do
  describe '.issue_token' do
    let(:user) { create(:user) }
    let(:payload) { { email: user.email, fractal_id: user.fractal_id } }

    context 'successfully' do
      subject { described_class.issue_token(payload) }
      it 'returns a token' do
        expect(subject).to be_present
      end

      it 'returns a token with 3 parts' do
        expect(subject.split('.').count).to eq(3)
      end

      it 'returns a token with the correct header' do
        header = JSON.parse(Base64.decode64(subject.split('.').first))
        expect(header).to eq('alg' => 'HS256')
      end
    end
  end

  describe '.decode_token' do
    let(:user) { create(:user) }
    let(:payload) { { email: user.email, fractal_id: user.fractal_id } }

    context 'successfully' do
      subject { described_class.issue_token(payload) }
      it 'returns a payload' do
        expect(described_class.decode_token(subject)).to include({ 'email' => user.email,
                                                                   'fractal_id' => user.fractal_id })
      end

      it 'returns a payload with the correct email' do
        expect(described_class.decode_token(subject)['email']).to eq(user.email)
      end

      it 'returns a payload with the correct fractal_id' do
        expect(described_class.decode_token(subject)['fractal_id']).to eq(user.fractal_id)
      end

      it 'returns key fractal_id' do
        expect(described_class.decode_token(subject)).to have_key('fractal_id')
      end

      it 'returns key email' do
        expect(described_class.decode_token(subject)).to have_key('email')
      end
    end

    context 'failure' do
      it 'returns error when token is invalid' do
        expect { described_class.decode_token('token') }.to raise_error(RuntimeError)
      end
    end
  end
end
