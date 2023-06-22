# frozen_string_literal: true

class Room < ApplicationRecord # rubocop:todo Style/Documentation
  belongs_to :app
  belongs_to :create_by, class_name: 'User', foreign_key: 'create_by_id'
  has_and_belongs_to_many :moderators, class_name: 'User', join_table: 'rooms_users'

  enum kind: { direct: 0, groups: 1, privates: 2, help_desk: 3 }

  validates :name, presence: true, length: { maximum: 20 }
  validates :name, uniqueness: { scope: :app_id }
  validates :closed_at, presence: true, if: :closed?
  validates :closed, presence: true, if: :help_desk? && :closed_at?

  validate :close_help_desk, on: :update

  def close_help_desk
    errors.add(:closed, ' Only help desk room can be closed') if help_desk? && closed?
  end

  def closed?
    closed
  end

  def opened?
    !closed?
  end

  def close!
    update!(closed: true, closed_at: Time.zone.now)
  end

  def open!
    update!(closed: false, closed_at: nil)
  end
end
