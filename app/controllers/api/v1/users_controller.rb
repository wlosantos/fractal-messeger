# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def index
        app = current_user.app

        users = User.all.where(app:)
        render json: users, status: :ok
      end
    end
  end
end
