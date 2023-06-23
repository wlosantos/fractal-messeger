require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "database" do
    context "must be present" do
      it { is_expected.to have_db_column(:content).of_type(:string) }
      it { is_expected.to have_db_column(:status_moderation).of_type(:integer).with_options(default: "blank") }
      it { is_expected.to have_db_column(:moderated_at).of_type(:datetime).with_options(default: nil) }
      it { is_expected.to have_db_column(:refused_at).of_type(:datetime).with_options(default: nil) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:parent_id).of_type(:integer) }
      it { is_expected.to have_db_column(:room_id).of_type(:integer) }
      it { is_expected.to have_db_column(:moderator_id).of_type(:integer) }
    end

    context "indexes" do
      it { is_expected.to have_db_index(:user_id) }
      it { is_expected.to have_db_index(:parent_id) }
      it { is_expected.to have_db_index(:room_id) }
      it { is_expected.to have_db_index(:moderator_id) }
    end
  end

  describe "associations" do
    before { allow_any_instance_of(Message).to receive(:message_permitted) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:parent).class_name("Message").optional.with_foreign_key(:parent_id) }
    it { is_expected.to belong_to(:room) }
    it { is_expected.to belong_to(:moderator).class_name("User").optional.with_foreign_key(:moderator_id) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status_moderation).with_values(blank: 0, pending: 1, approved: 2, refused: 3) }
  end

  describe "create message" do
    let!(:room) { create(:room) }
    
    context "with valid attributes" do
      let(:user) { create(:room_participant, room: room) }
      let(:message) { build(:message, user: user.user, room: room) }

      it { expect(message).to be_valid }
    end
    
    context "when user blocked" do
      let!(:participant) { create(:room_participant, is_blocked: true, room:) }
      let(:message) { build(:message, user: participant.user, room: room) }
      before { message.valid? }

      it { expect(message).to_not be_valid }
      it { expect(message.errors.full_messages).to include("User is blocked to send message") }
    end

    context "when user is not participant" do
      let(:new_user) { create(:user) }
      let(:message) { build(:message, user: new_user, room: room) }
      before { message.valid? }

      it { expect(message).to_not be_valid }
      it { expect(message.errors.full_messages).to include("User is not participant") }
    end

    context "when room is closed" do
      let(:message) { build(:message, room: room) }
      before { room.update(closed: true) }
      before { message.valid? }

      it { expect(message).to_not be_valid }
      it { expect(message.errors.full_messages).to include("Room is closed") }
    end
  end
end
