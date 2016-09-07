##
# Routes configuration
#
# The application will need to be reloaded after changes for them to take effect
##

Rails.application.routes.draw do
  # api v1
  namespace :v1 do
    # simple routes
    resources :data, only: [:create]
    resources :devices, only: [:create, :index, :show]
    resources :groups, only: [:create, :index, :show]
    resources :users, only: [:create, :index]

    # extra data routes
    controller :data do
      match 'data/:device_id', to: 'data#show', via: :get
    end

    # extra groups routes
    controller :groups do
      match 'groups/add_users', to: 'groups#add_users', via: :post
      match 'groups/remove_users', to: 'groups#remove_users', via: :post
    end

    # extra users routes
    controller :users do
      match 'users/:email', to: 'users#show', via: :get
      match 'users/reset_password', to: 'users#reset_password', via: [:post]
      match 'users/login', to: 'users#login', via: [:post]
      match 'users/logout', to: 'users#logout', via: [:post]
      match 'users/update_details', to: 'users#update_details', via: [:patch, :put]
    end
  end
end
