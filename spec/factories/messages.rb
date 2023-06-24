# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence(word_count: 3) }
    status_moderation { %i[blank pending approved refused].sample }
    moderated_at { nil }
    refused_at { nil }
    moderator
    user
    room
  end
end
