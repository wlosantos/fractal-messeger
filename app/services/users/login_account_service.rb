# frozen_string_literal: true

module Users
  class LoginAccountService < ApplicationService
    attr_reader :token, :dg_user, :app

    def initialize(token: nil, dg_user: nil, app: nil)
      @token = token
      @dg_user = dg_user
      @app = app
    end

    def call
      return false unless @token || @dg_user

      account
    end

    private

    def account
      account = User.find_by(email: @dg_user[:email], fractal_id: @dg_user[:fractal_id])
      if account.present? && account.update(dg_token: @token)
        JwtAuth::TokenProvider.issue_token({ email: account.email, fractal_id: account.fractal_id })
      else
        return false unless @app
        return false unless app_dg

        user = User.create(name: @dg_user[:name], email: @dg_user[:email], fractal_id: @dg_user[:fractal_id], dg_token: @token,
                           app_id: app_dg.id)
        JwtAuth::TokenProvider.issue_token({ email: user.email, fractal_id: user.fractal_id })
      end
    end

    def app_dg
      app = App.find_by(dg_app_id: @app)
      return app if app

      dg_app = Api::DgAppService.new(token: @token, app: @app).call
      return false unless dg_app

      app = JSON.parse(dg_app.body, symbolize_names: true)
      App.create(dg_app_id: app[:id], name: app[:name])
    end
  end
end
