# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :webmock, :faraday
  config.cassette_library_dir = 'spec/support/cassettes'
  config.ignore_localhost = true
  config.default_cassette_options = {
    record: :once, match_requests_on: %i[method host path query headers]
  }
  # configure.before_record { |i| i.response.body.force_encoding('UTF-8') }
  config.configure_rspec_metadata!
end
