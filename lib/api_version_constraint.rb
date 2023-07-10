# frozen_string_literal: true

class ApiVersionConstraint # rubocop:todo Style/Documentation
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.fractal-messeger.v#{@version}")
  end
end
