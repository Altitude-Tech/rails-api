Rails.application.routes.draw do
  # pages
  # users
  # session
  # devices
  # data

  # base pages
  root 'pages#home'
  get 'dashboard', to: 'pages#dashboard', format: false
  get 'profile', to: 'pages#profile', format: false



end
