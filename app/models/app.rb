# frozen_string_literal: true

class App < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :rooms, dependent: :destroy

  validates :name, :dg_app_id, presence: true
  validates :dg_app_id, uniqueness: true
end
