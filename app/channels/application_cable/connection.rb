# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'MessagesCable', current_user.email
    end

    # protected
    def find_verified_user
      if (current_user = User.find_by(fractal_id: request.params[:fractal_id]))
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
