# frozen_string_literal: true

module Api
  class DgAuthService < ApplicationService
    attr_reader :conn, :token

    def initialize(token:)
      @token = token
      @conn = Api::ConnectService.new(token:).call
    end

    def call
      is_token? ? auth : { error: 'No token' }
    end

    def auth
      @conn.post do |req|
        req.url 'api/v1/users/check'
      end
    rescue Faraday::ConnectionFailed => e
      { error: e.message }
    end

    def is_token?
      @token.present?
    end
  end
end
