# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do # rubocop:todo Metrics/BlockLength
  describe 'database' do
    context 'must be present' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:kind).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:read_only).of_type(:boolean).with_options(null: false, default: false) }
      it { is_expected.to have_db_column(:moderated).of_type(:boolean).with_options(null: false, default: false) }
      it { is_expected.to have_db_column(:closed).of_type(:boolean) }
      it { is_expected.to have_db_column(:closed_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:create_by_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:app_id).of_type(:integer).with_options(null: false) }
    end

    context 'indexes' do
      it { is_expected.to have_db_index(:create_by_id) }
      it { is_expected.to have_db_index(:app_id) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:app) }
    it { is_expected.to belong_to(:create_by).class_name('User') }
  end

  describe 'validations' do
    subject { build(:room, closed: true) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(20) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:app_id).ignoring_case_sensitivity }
    it { is_expected.to validate_presence_of(:closed_at) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:kind).with_values(direct: 0, groups: 1, privates: 2, help_desk: 3) }
  end

  describe 'methods' do # rubocop:todo Metrics/BlockLength
    describe '#closed?' do
      context 'when closed is true' do
        subject { build(:room, closed: true) }
        it { expect(subject.closed?).to be_truthy }
      end

      context 'when closed is false' do
        subject { build(:room, closed: false) }
        it { expect(subject.closed?).to be_falsey }
      end
    end

    describe '#opened?' do
      context 'when closed is true' do
        subject { build(:room, closed: true) }
        it { expect(subject.opened?).to be_falsey }
      end

      context 'when closed is false' do
        subject { build(:room, closed: false) }
        it { expect(subject.opened?).to be_truthy }
      end
    end

    describe '#close!' do
      subject { build(:room, closed: true, kind: :help_desk) }
      it { expect(subject.close!).to be_truthy }
    end

    describe '#open!' do
      subject { build(:room, closed: true) }
      it { expect(subject.open!).to be_truthy }
    end
  end
end
