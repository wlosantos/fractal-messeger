# frozen_string_literal: true

module Api
  class DgAppService < ApplicationService
    attr_reader :conn, :token, :app

    def initialize(token:, app:)
      @token = token
      @app = app
      @conn = Api::ConnectService.new(token:).call
    end

    def call
      is_token? && is_app? ? dg_app : { error: 'No token' }
    end

    def dg_app
      @response || @conn.get do |req|
        req.url "api/v1/applications/#{@app}"
      end
    rescue Faraday::ConnectionFailed => e
      { error: e.message }
    end

    def is_token?
      @token.present?
    end

    def is_app?
      @app.present?
    end
  end
end
