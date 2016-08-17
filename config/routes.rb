Rails.application.routes.draw do
  # @todo remove index
  # api for submitting data
  resources :api, only: [:index, :create]

  scope 'api' do
    # for getting data for a given device
    resources :devices, only: [:index, :show]
  end
end
