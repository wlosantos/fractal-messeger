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
    it { is_expected.to have_and_belong_to_many(:moderators).class_name('User') }
    it { is_expected.to have_many(:room_participants).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:room_participants) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:room, closed: true) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:app_id).ignoring_case_sensitivity }
    it { is_expected.to validate_presence_of(:closed_at) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:kind).with_values(direct: 0, groups: 1, privates: 2, help_desk: 3) }
  end

  describe 'created a room' do # rubocop:todo Metrics/BlockLength
    context 'successfully' do
      it 'with valid attributes' do
        expect(build(:room)).to be_valid
      end
    end

    context 'failure' do
      it 'without name' do
        expect(build(:room, name: nil)).not_to be_valid
      end

      it 'with duplicate name' do
        app = create(:app)
        create(:room, name: 'test', app:)
        expect(build(:room, name: 'test', app:)).not_to be_valid
      end

      it 'without app' do
        expect(build(:room, app: nil)).not_to be_valid
      end

      it 'without create_by' do
        expect(build(:room, create_by: nil)).not_to be_valid
      end

      it 'when closed room without closed_at' do
        expect(build(:room, closed: true, closed_at: nil)).not_to be_valid
      end

      it 'when closed room with closed_at' do
        expect(build(:room, closed: true, closed_at: Time.zone.now)).to be_valid
      end
    end
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
      context 'when kind is help_desk' do
        subject { build(:room, closed: false, kind: :help_desk) }
        it { expect(subject.close!).to be_truthy }
      end

      context 'when kind is not help_desk' do
        subject { build(:room, closed: true, kind: :direct) }
        it { expect(subject.close!).to be_falsey }
      end
    end

    describe '#open!' do
      context 'when kind is help_desk' do
        subject { build(:room, kind: :help_desk, closed: true) }
        it { expect(subject.open!).to be_truthy }
      end

      context 'when kind is not help_desk' do
        subject { build(:room, kind: :direct, closed: true) }
        it { expect(subject.open!).to be_falsey }
      end
    end
  end
end
