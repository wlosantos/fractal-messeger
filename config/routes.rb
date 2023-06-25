# frozen_string_literal: true

require 'api_version_constraint'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :registrations, only: %i[create]
      resources :sessions, only: %i[create]
      resources :users, only: %i[index]
    end
  end
end
