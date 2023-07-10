# frozen_string_literal: true

require 'faraday'

module Users
  class DecodeService < ApplicationService
    attr_accessor :user_application_id, :datagateway_token, :url, :conn

    def initialize(args, conn = nil) # rubocop:todo Lint/MissingSuper
      @user_application_id = args[:user_application_id]
      @datagateway_token = args[:datagateway_token]
      @url = args[:url]

      @conn = conn || Faraday.new(
        url: @url,
        headers: { 'X-Token' => @datagateway_token }
      )
    end

    def call
      return false unless user_data

      resp = user_data

      JSON.parse(resp.body, symbolize_names: true)
    end

    private

    def user_data
      return false unless @user_application_id && @datagateway_token && @url

      @conn.post('/api/v1/users/check')
    rescue Faraday::ConnectionFailed => e
      puts "Error: #{e.message}"
    end
  end
end
