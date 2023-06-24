# frozen_string_literal: true

FactoryBot.define do
  factory :room_participant do
    is_blocked { false }
    user
    room

    trait :blocked do
      is_blocked { true }
    end
  end
end
