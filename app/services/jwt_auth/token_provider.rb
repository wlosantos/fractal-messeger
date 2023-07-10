# frozen_string_literal: true

module JwtAuth
  class TokenProvider
    ALGORITHM = 'HS256'

    def self.issue_token(payload)
      JWT.encode(payload, secret_key, ALGORITHM)
    end

    def self.decode_token(token)
      JWT.decode(token, secret_key, true, algorithm: ALGORITHM)[0]
    rescue JWT::DecodeError
      raise "Invalid Token: #{token}"
    end

    def self.valid_payload?(payload)
      payload[:email] && payload[:fractal_id]
    end

    def self.secret_key
      Rails.application.secrets.secret_key_base.to_s.freeze
    end
  end
end
