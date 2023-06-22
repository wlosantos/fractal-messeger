# frozen_string_literal: true

class App < ApplicationRecord # rubocop:todo Style/Documentation
  validates :name, :dg_app_id, presence: true
  validates :dg_app_id, uniqueness: true
end
