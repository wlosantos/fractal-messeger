# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App, type: :model do # rubocop:todo Metrics/BlockLength
  describe 'database' do
    context 'must be present' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:dg_app_id).of_type(:integer).with_options(null: false) }
    end
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:dg_app_id) }
    end

    context 'uniqueness' do
      subject { FactoryBot.create(:app) }

      it { is_expected.to validate_uniqueness_of(:dg_app_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:destroy) }
    #   it { is_expected.to have_many(:rooms).dependent(:destroy) }
  end

  describe 'create app' do
    context 'successfully' do
      subject { create(:app) }
      it { is_expected.to be_valid }
    end

    context 'failure - without name' do
      subject { build(:app, name: nil) }
      it { is_expected.to_not be_valid }
    end
  end
end
