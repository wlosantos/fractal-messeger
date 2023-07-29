# frozen_string_literal: true

module Users
  class HasAccountService < ApplicationService
    attr_reader :token

    def initialize(token = nil)
      @token = token
    end

    def call
      @token ? account : false
    end

    private

    def account
      user = User.find_by(dg_token: @token)
      return false unless user

      JwtAuth::TokenProvider.issue_token({ email: user.email, fractal_id: user.fractal_id })
    end
  end
end
