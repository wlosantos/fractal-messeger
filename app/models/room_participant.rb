# frozen_string_literal: true

class RoomParticipant < ApplicationRecord # rubocop:todo Style/Documentation
  belongs_to :user
  belongs_to :room

  validates :user_id, uniqueness: { scope: :room_id }
  validates :is_blocked, inclusion: { in: [true, false] }
end
