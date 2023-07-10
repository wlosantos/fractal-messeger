# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomPolicy, type: :policy do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let(:room) { create(:room, create_by: user) }
  let(:room2) { create(:room, create_by: admin) }
  subject { described_class }

  permissions :index? do
    it 'denies access if user is not admin or owner' do
      expect(subject).not_to permit(user, room2)
    end

    it 'grants access if user is owner' do
      expect(subject).to permit(user, room)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, room2)
      expect(subject).to permit(admin, room)
    end
  end

  permissions :show? do
    it 'denies access if user is not admin or owner' do
      expect(subject).not_to permit(user, room2)
    end

    it 'grants access if user is owner' do
      expect(subject).to permit(user, room)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, room2)
      expect(subject).to permit(admin, room)
    end
  end

  permissions :create? do
    it 'grants access if user is owner' do
      expect(subject).to permit(user, room)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, room2)
      expect(subject).to permit(admin, room)
    end
  end

  permissions :update? do
    it 'denies access if user is not admin or owner' do
      expect(subject).not_to permit(user, room2)
    end

    it 'grants access if user is owner' do
      expect(subject).to permit(user, room)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, room2)
      expect(subject).to permit(admin, room)
    end
  end

  permissions :destroy? do
    it 'denies access if user is not admin or owner' do
      expect(subject).not_to permit(user, room2)
    end

    it 'grants access if user is owner' do
      expect(subject).to permit(user, room)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, room2)
      expect(subject).to permit(admin, room)
    end
  end
end
