# frozen_string_literal: true

class User < ApplicationRecord # rubocop:todo Style/Documentation
  rolify

  belongs_to :app
  has_many :rooms, foreign_key: 'create_by_id', dependent: :destroy
  has_and_belongs_to_many :rooms_moderators, class_name: 'Room', join_table: 'rooms_users'

  validates :name, :email, :fractal_id, :dg_token, presence: true
  validates :email, :fractal_id, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :assign_default_role

  private

  def assign_default_role
    add_role(:admin) if User.count == 1
    add_role(:user) if roles.blank?
  end
end
