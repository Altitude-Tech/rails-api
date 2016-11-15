Rails.application.routes.draw do
  # handle OPTIONs requests for CORS support
  match '*anything', to: 'v1/api#options', via: :options

  namespace :v1, format: false do
    # basic user routes
    resources :users, only: [:create]

    # non-standard user routes
    controller :users do
      match 'users', to: 'users#show', via: :get
      match 'users', to: 'users#update', via: :put
      match 'users/login', to: 'users#login', via: :post
      match 'users/logout', to: 'users#logout', via: :post
      match 'users/reset_password', to: 'users#reset_password', via: :post
    end

    # basic group routes
    resources :groups, only: [:create]

    # non-standard group routes
    controller :groups do
      match 'groups', to: 'groups#show', via: :get
      match 'groups/add_user', to: 'groups#add_user', via: :post
    end

    # non-standard devices routes
    controller :devices do
      match 'devices/register', to: 'devices#register', via: :post
    end

    # basic data routes
    resources :data, only: [:create, :show], param: :identity

    # basic token routes
    resources :tokens, only: [:create]

    # admin-only routes
    namespace :admin do
      resources :devices, only: [:create]
    end
  end
end
