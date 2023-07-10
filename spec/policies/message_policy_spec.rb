require "rails_helper"

RSpec.describe MessagePolicy, type: :policy do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:participant) { create(:room_participant, user: user) }
  let(:message) { create(:message, user: user, room: participant.room) }
  let(:message2) { create(:message) }

  subject { described_class }

  permissions :create? do
    it "grants access if user is owner" do
      expect(subject).to permit(user, message)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, message)
    end
  end

  permissions :update? do
    it "grants access if user is owner" do
      expect(subject).to permit(user, message)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, message)
    end
  end

  permissions :destroy? do
    it "grants access if user is owner" do
      expect(subject).to permit(user, message)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, message)
    end
  end
end