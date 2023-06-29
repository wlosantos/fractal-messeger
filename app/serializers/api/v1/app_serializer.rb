# frozen_string_literal: true

module Api
  module V1
    # Show app and your rooms and contacts
    class AppSerializer < ActiveModel::Serializer
      attributes :id, :name, :app_id, :contacts

      def app_id
        object.dg_app_id
      end

      def contacts
        object.users.map do |contact|
          {
            id: contact.id,
            name: contact.name,
            email: contact.email,
            fractalId: contact.fractal_id
          }
        end
      end

      def attributes(*args)
        hash = super
        if @instance_options[:show_rooms]
          hash[:rooms] = object.rooms.map do |room|
            {
              id: room.id,
              name: room.name,
              kind: room.kind,
              createBy: room.create_by
            }
          end
        end

        hash
      end
    end
  end
end
