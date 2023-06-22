# frozen_string_literal: true

class App < ApplicationRecord # rubocop:todo Style/Documentation
  has_many :users, dependent: :destroy

  validates :name, :dg_app_id, presence: true
  validates :dg_app_id, uniqueness: true
end
