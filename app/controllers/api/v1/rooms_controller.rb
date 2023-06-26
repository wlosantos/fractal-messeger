# frozen_string_literal: true

module Api
  module V1
    class RoomsController < ApplicationController
      before_action :set_room, only: %i[show update destroy participants add_participant remove_participant change_blocked]
      before_action :set_room_participant, only: %i[remove_participant change_blocked]

      def index
        app = App.find(params[:app_id])
        rooms = current_user.has_role?(:admin) ? Room.all : app.rooms.where(origin_id: current_user.id)

        authorize rooms
        render json: rooms, status: :ok
      end

      def show
        authorize @room
        # render json: @room, serializer: RoomSerializer, show_messager: true, status: :ok
        render json: @room, status: :ok
      end

      def create
        app = App.find(params[:app_id])

        return unless app

        room = Room.new(room_params.merge(create_by: current_user, app_id: app.id))
        authorize room

        if room.save
          render json: room, status: :created
        else
          render json: { errors: room.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @room

        if @room.update(room_params)
          render json: @room, status: :ok
        else
          render json: { errors: @room.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @room

        @room.destroy
        head 204
      end

      def add_participant
        room_participant = @room.room_participants.new(room_participant_params)
        if @room.room_participants.exists?(user_id: room_participant.user_id)
          render json: { errors: { message: 'User already exists' } }, status: :unprocessable_entity
        elsif room_participant.save
          render json: room_participant, status: :created
        else
          render json: { errors: room_participant.errors }, status: :unprocessable_entity
        end
      end

      def remove_participant
        return unless @room_participant.destroy

        head 204
      end

      def change_blocked
        @room_participant.update(is_blocked: !@room_participant.is_blocked)
        render json: @room_participant, status: :ok
      end

      private

      def set_room
        @room = Room.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head 404
      end

      def set_room_participant
        @room_participant = @room.room_participants.find(params[:room_participant])
      rescue ActiveRecord::RecordNotFound
        head 404
      end

      def room_params
        params.require(:room).permit(:name, :kind, :read_only, :moderated, :closed)
      end

      def room_participant_params
        params.require(:room_participant).permit(:user_id, :is_moderator, :is_blocked)
      end
    end
  end
end
