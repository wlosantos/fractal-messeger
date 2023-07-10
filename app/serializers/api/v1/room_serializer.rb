# frozen_string_literal: true

module Api
  module V1
    # Show room and your messages and participants
    class RoomSerializer < ActiveModel::Serializer
      attributes :id, :name, :kind, :create_by, :read_only, :moderated, :app, :status, :moderators, :participants

      def create_by
        object.create_by.name
      end

      def app
        object.app.name
      end

      def status
        object.closed? ? 'closed' : 'open'
      end

      def participants
        object.room_participants.map do |room_participant|
          {
            RoomParticipantId: room_participant.id,
            userId: room_participant.user_id,
            name: room_participant.user.name,
            moderator: room_participant.user.rooms_moderators.exists?(id: object.id),
            blocked: room_participant.is_blocked
          }
        end
      end

      def moderators
        object.moderators.map do |moderator|
          {
            userId: moderator.id,
            name: moderator.name
          }
        end
      end

      def attributes(*args)
        hash = super
        if @instance_options[:show_messager]
          hash[:messages] = object.messages.map do |message|
            {
              id: message.id,
              userId: message.user_id,
              author: message.user.name,
              content: message.content,
              createdAt: message.created_at.strftime('%d/%m/%Y %H:%M')
            }
          end
        end
        hash
      end
    end
  end
end
