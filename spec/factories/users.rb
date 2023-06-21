# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{name.split(' ').join('-')}@" + Faker::Internet.domain_name }
    fractal_id { rand(1_000..10_000).to_s }
    dg_token { Faker::Lorem.sentence(word_count: 6).split(' ').join('-').downcase }
  end
end
