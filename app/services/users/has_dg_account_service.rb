# frozen_string_literal: true

module Users
  class HasDgAccountService < ApplicationService
    attr_reader :token

    def initialize(token = nil)
      @token = token
    end

    def call
      return false unless @token

      dg_account
    end

    private

    def dg_account
      Api::DgAuthService.new(token: @token).call
    end
  end
end
