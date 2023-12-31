# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_message, only: %i[update destroy]

      def create
        room = Room.where(id: params[:room_id]).first
        if room.present? && !room.read_only?
          message = current_user.messages.build(message_params.merge(room:))

          if message.save
            render json: message, status: :created
          else
            render json: { errors: message.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: 'Room dont exist, closed, or is read only' }, status: :not_found
        end
      end

      def destroy
        authorize @message
        @message.destroy
        head :no_content
      end

      private

      def set_message
        @message = Message.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def message_params
        params.require(:message).permit(
          :content,
          :status_moderation,
          :moderated_at,
          :refused_at,
          :moderator_id,
          :parent_id
        )
      end
    end
  end
end
