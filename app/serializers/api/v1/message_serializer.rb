# frozen_string_literal: true

module Api
  module V1
    class MessageSerializer < ActiveModel::Serializer
      attributes :id, :content, :status_moderation, :moderated_at, :refused_at, :moderator_id, :parent_id, :created_at,
                 :updated_at, :user_id, :room_id, :author

      def author
        object.user.name
      end
    end
  end
end
