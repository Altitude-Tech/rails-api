Rails.application.routes.draw do
  namespace :v1 do
    # basic user routes
    resources :users, only: [:create, :show], param: :email

    # non-standard user routes
    controller :users do
      match 'users/login', to: 'users#login', via: :post
      match 'users/logout', to: 'users#logout', via: :post
      match 'users/:email/group', to: 'users#group', via: :post
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

    # admin-only routes
    namespace :admin do
      resources :devices, only: [:create]
    end
  end
end
