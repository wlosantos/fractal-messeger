# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :autenticate!, only: :create

      def create
        dg_data = Users::DecodeService.call(user_params)

        if dg_data
          app = App.find_or_create_by(dg_app_id: params[:user_application_id].to_i, name: params[:user_application_name])

          if app
            dg_token = params[:datagateway_token]

            user = User.new(name: dg_data[:name], email: dg_data[:email], fractal_id: dg_data[:fractal_id],
                            app_id: app.id, dg_token:)

            if user.save
              render json: { success: 'Welcome! You have signed up successfully.' }, status: :created
            else
              render json: { errors: user.errors }, status: :unprocessable_entity
            end
          else
            render json: { errors: app.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: dg_data }, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:user_application_id, :user_application_name, :datagateway_token, :url)
      end
    end
  end
end
