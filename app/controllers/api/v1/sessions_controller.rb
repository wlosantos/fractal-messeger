# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :autenticate!, only: :create
      before_action :token_params, only: :create

      def create
        if @token
          account_token = Users::HasAccountService.call(@token)

          if account_token
            response.headers['Authorization'] = "Bearer #{account_token}"
            render json: { token: account_token }, status: :ok

          else
            auth = Users::HasDgAccountService.call(@token)

            if auth[:error]
              logger_message(auth[:error])
              render json: { error: auth[:error] }, status: :unauthorized
            else
              dg_user = JSON.parse(auth.body, symbolize_names: true)
              account_token = Users::LoginAccountService.new(token: @token, dg_user:,
                                                             app: params[:user_application_id]).call

              if account_token
                response.headers['Authorization'] = "Bearer #{account_token}"
                render json: { token: account_token }, status: :ok
              else
                render json: { error: 'Invalid credentials' }, status: :unauthorized
              end
            end
          end
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      private

      def token_params
        @token = params[:token]
      end

      def logger_message(message)
        logger.error "[#{Time.now}] - #{message}"
      end
    end
  end
end
