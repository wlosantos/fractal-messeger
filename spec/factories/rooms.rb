# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    name { Faker::Lorem.sentences(number: 1).first }
    kind { %w[direct groups privates help_desk].sample }
    read_only { false }
    moderated { false }
    closed { false }
    closed_at { closed? ? DateTime.now : nil }
    create_by
    app
  end
end
