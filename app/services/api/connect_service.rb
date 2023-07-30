# frozen_string_literal: true

module Api
  class ConnectService < ApplicationService
    attr_reader :conn

    def initialize(token:)
      @conn = Faraday.new(
        url: 'https://staging.datagateway.fractaltecnologia.com.br',
        headers: {
          'Content-Type' => 'application/json',
          'X-Token' => token
        }
      )
    end

    def call
      @conn
    end
  end
end
