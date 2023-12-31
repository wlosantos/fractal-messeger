# frozen_string_literal: true

FactoryBot.define do
  factory :app do
    name { Faker::App.name }
    dg_app_id { rand(1...9999) }
  end
end
