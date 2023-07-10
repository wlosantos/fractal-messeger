# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: current_user, status: :ok
      end
    end
  end
end
