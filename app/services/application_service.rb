# frozen_string_literal: true

class ApplicationService # rubocop:todo Style/Documentation
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
