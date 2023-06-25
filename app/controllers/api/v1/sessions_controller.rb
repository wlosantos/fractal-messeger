# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :autenticate!, only: :create

      def create
        user = User.find_by(email: params[:email])

        if user&.fractal_id == params[:fractal_id]
          token = JwtAuth::TokenProvider.issue_token({ email: user.email, fractal_id: user.fractal_id })
          response.headers['Authorization'] = "Bearer #{token}"
          render json: { token: }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
    end
  end
end
