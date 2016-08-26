Rails.application.routes.draw do
  # api v1
  namespace :v1 do
    # simple routes
    resources :data, only: [:create]
    resources :devices, only: [:create, :index, :show]
    resources :users, only: [:create, :index]

    # extra data routes
    controller :data do
      match 'data/:device_id', to: 'data#show', via: :get
    end

    # extra users routes
    controller :users do
      match 'users/:email', to: 'users#show', via: :get
      match 'users/:email', to: 'users#update', via: [:patch, :put]
      match 'users/authenticate', to: 'users#authenticate', via: [:post]
      match 'users/change_password', to: 'users#change_password', via: [:patch, :put]
    end
  end
end
