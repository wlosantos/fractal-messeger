# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[create_by moderator] do
    name { Faker::Name.name }
    email { "#{name.split(' ').join('-')}@" + Faker::Internet.domain_name }
    fractal_id { rand(1_000..10_000).to_s }
    dg_token { Faker::Lorem.sentence(word_count: 6).split(' ').join('-').downcase }
    app

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :moderator do
      after(:create) { |user| user.add_role(:moderator) }
    end

    trait :user do
      after(:create) { |user| user.add_role(:user) }
    end
  end
end
