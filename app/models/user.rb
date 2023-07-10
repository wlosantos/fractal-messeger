# frozen_string_literal: true

class User < ApplicationRecord
  rolify

  belongs_to :app
  has_many :room_participants, dependent: :destroy
  has_many :rooms, through: :room_participants
  has_many :create_by, class_name: 'Room', foreign_key: 'create_by_id', dependent: :destroy
  has_and_belongs_to_many :rooms_moderators, class_name: 'Room', join_table: 'rooms_users'
  has_many :messages, dependent: :destroy

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
