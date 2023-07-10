# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :name, :email, :fractal_id, :app_id, :roles

      def roles
        object.roles.pluck(:name)
      end
    end
  end
end
