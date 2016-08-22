Rails.application.routes.draw do
  namespace :v1 do
    controller :data do
      match 'data', to: 'data#create', via: :post
      match 'data/:device_id', to: 'data#show', as: :device_id, via: :get
    end

    resources :devices, only: [:create, :index, :show]
    resources :users, only: [:create, :index, :show, :update]
  end
end
