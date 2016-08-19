Rails.application.routes.draw do
  namespace :v1 do
    # for submitting data
    resources :data, only: [:index, :create]
    # for getting devices
    resources :devices, only: [:index, :show]
  end
end
