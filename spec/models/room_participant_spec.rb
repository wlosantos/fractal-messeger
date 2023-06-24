# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomParticipant, type: :model do
  describe 'database' do
    context 'must be present' do
      it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:room_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:is_blocked).of_type(:boolean).with_options(null: false, default: false) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:room) }
  end

  describe 'validations' do
    context 'uniqueness' do
      subject { create(:room_participant) }
      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:room_id) }
    end
  end

  describe 'create room participant' do
    context 'successfully' do
      subject { create(:room_participant) }
      it { is_expected.to be_valid }
    end

    context 'failure - without user' do
      subject { build(:room_participant, user: nil) }
      it { is_expected.to_not be_valid }
    end

    context 'failure - without room' do
      subject { build(:room_participant, room: nil) }
      it { is_expected.to_not be_valid }
    end
  end
end
