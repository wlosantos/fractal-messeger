require "rails_helper"

RSpec.describe AppPolicy, type: :policy do
  let!(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:app) { create(:app) }
  subject { described_class }

  permissions :index? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(user, app)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, app)
    end
  end

  permissions :show? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(user, app)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, app)
    end
  end

  permissions :create? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(user, app)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, app)
    end
  end

  permissions :update? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(user, app)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, app)
    end
  end

  permissions :destroy? do
    it "denies access if user is not admin" do
      expect(subject).not_to permit(user, app)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, app)
    end
  end
end
