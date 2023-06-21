# frozen_string_literal: true

class User < ApplicationRecord # rubocop:todo Style/Documentation
  validates :name, :email, :fractal_id, :dg_token, presence: true
  validates :email, :fractal_id, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
