# frozen_string_literal: true

require 'api_version_constraint'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount ActionCable.server => '/cable'

  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :sessions, only: %i[create]
      resources :users, only: %i[index]
      resources :apps do
        resources :rooms, only: %i[index create]
      end
      resources :rooms, only: %i[show update destroy] do
        member do
          get '/participants', to: 'rooms#participants'
          post '/participants', to: 'rooms#add_participant'
          delete '/participants/:room_participant', to: 'rooms#remove_participant'
          put '/participants/:room_participant', to: 'rooms#change_blocked'
        end

        member do
          put '/moderators/:room_participant', to: 'rooms#change_moderator'
        end

        resources :messages, only: %i[create]
      end
      resources :messages, only: %i[destroy]
    end
  end
end
