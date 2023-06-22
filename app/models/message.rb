class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :parent, class_name: 'Message', optional: true, foreign_key: 'parent_id'
  belongs_to :moderator, class_name: 'User', optional: true, foreign_key: 'moderator_id'

  enum status_moderation: { blank: 0, pending: 1, approved: 2, refused: 3 }

  validates :content, presence: true, length: { maximum: 240 }
end
